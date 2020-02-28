const firebase = require("@firebase/testing");
const fs = require("fs");

/*
 * ============
 *    Setup
 * ============
 */
const projectId = "firestore-emulator-example";
const port = 8080;
const coverageUrl = `http://localhost:${port}/emulator/v1/projects/${projectId}:ruleCoverage.html`;

const rules = fs.readFileSync("firestore.rules", "utf8");

/**
 * Creates a new app with authentication data matching the input.
 *
 * @param {object} auth the object to use for authentication (typically {uid: some-uid})
 * @return {object} the app.
 */
function authedApp(auth) {
  return firebase.initializeTestApp({ projectId, auth }).firestore();
}

/*
 * ============
 *  Test Cases
 * ============
 */
beforeEach(async () => {
  // Clear the database between tests
  await firebase.clearFirestoreData({ projectId });
});

before(async () => {
  await firebase.loadFirestoreRules({ projectId, rules });
});

after(async () => {
  await Promise.all(firebase.apps().map(app => app.delete()));
  console.log(`View rule coverage information at ${coverageUrl}\n`);
});

describe("My app", () => {
  it("require users to log in before creating a user", async () => {
    // mock not isauthenticated user
    const db = authedApp(null);
    // get user document ref
    const user = db.collection("users").doc("alice");

    const query = user.set({ name: "Alice" });
    await firebase.assertFails(query);
  });

  it("should let anyone read any published posts", async () => {  
    const db = authedApp(null);
    const queryPublished = db.collectionGroup('posts').where("published", "==", true).get();
    const queryDrafts = db.collectionGroup('posts').where("published", "==", false).get();
    await firebase.assertSucceeds(queryPublished);
    await firebase.assertFails(queryDrafts);
  });

  it("should only let users to query their own post", async () => {
    // mock isAuthenticated user (alice)
    const db = authedApp({ uid: "alice" });
    await firebase.assertSucceeds(
      db
        .collection("users")
        .doc("alice")
        .collection("posts")
        .get()
    );
    await firebase.assertFails(
      db
        .collection("users")
        .doc("bob")
        .collection("posts")
        .get()
    );
  });

  it("should not allow to read other's draft post", async () => {
    const alice = authedApp({ uid: "alice" });
    const bob = authedApp({ uid: "bob" });

    // Make alice's draft post
    const aliceDraftPost = alice.collection("users").doc("alice").collection("posts").doc("alice-post1");
    await aliceDraftPost.set({title: "title", published: false});

    // Make alice's published post
    const alicePublicPost = alice.collection("users").doc("alice").collection("posts").doc("alice-post2");
    await alicePublicPost.set({title: "title", published: true});

    // Bob access alice's draft post
    const bobQuery1 = bob.collection("users").doc("alice").collection("posts").doc("alice-post1").get();

    // Bob access alice's published post
    const bobQuery2 = bob.collection("users").doc("alice").collection("posts").doc("alice-post2").get();

    // Alice access alice's draft post
    const aliceQuery = aliceDraftPost.get();

    await firebase.assertFails(bobQuery1);
    await firebase.assertSucceeds(bobQuery2);
    await firebase.assertSucceeds(aliceQuery);
  });

  it("require users to log in before creating a post", async () => {
    const db = authedApp(null);
    const query = db.collection("users").doc("alice")
                    .collection("posts").doc()
                    .set({
                      title: "alice",
                      content: "All Things Firebase"
                    })
    await firebase.assertFails(query);
  });

  it("requires title field to create a post", async () => {
    const db = authedApp({ uid: "alice" });
    const postDocRef = db.collection("users").doc("alice").collection("posts").doc()
                  
    await firebase.assertFails(postDocRef.set({title: ""}));
    await firebase.assertSucceeds(postDocRef.set({title: "title 1"}));
  });

  it("should not allow to update other's post", async () => {
    const alice = authedApp({ uid: "alice" });
    const bob = authedApp({ uid: "bob" });

    // Make bob's post
    await bob.collection("users").doc("bob")
      .collection("posts").doc("bobPost1")
      .set({title: "hogehoge"});

    // alice query to update bob's post
    aliceQuery = alice.collection("users").doc("bob")
                  .collection("posts").doc("bobPost1")
                  .update({title: "hoge"});
                  
    await firebase.assertFails(aliceQuery);
  });

  it("requires title field to update a post", async () => {
    const db = authedApp({ uid: "alice" });
    const postDocRef = db.collection("users").doc("alice").collection("posts").doc("post1");
    await postDocRef.set({title: "hogehoge"});
                  
    await firebase.assertFails(postDocRef.update({title: ""}));
    await firebase.assertSucceeds(postDocRef.update({title: "title 1"}));
  });

  it("should not allow to delete other's post", async () => {
    const alice = authedApp({ uid: "alice" });

    // alice query to update bob's post
    aliceQuery = alice.collection("users").doc("bob")
                  .collection("posts").doc("bobPost1")
                  .delete();
                  
    await firebase.assertFails(aliceQuery);
  });
});