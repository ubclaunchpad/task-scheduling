import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {GroupType} from "./types";
admin.initializeApp();
admin.firestore().settings({
  ignoreUndefinedProperties: true,
});

// Start writing Firebase Functions
// https://firebase.google.com/docs/functions/typescript
//
export const helloWorld = functions.https.onRequest((request, response) => {
  functions.logger.info("Hello logs!", {structuredData: true});
  response.send("Hello from Firebase!");
});

const getGroupFromRequest = (request: functions.Request): GroupType => {
  return request.body;
};

export const createGroup = functions.https
    .onRequest(async (request, response) => {
      const group = {...getGroupFromRequest(request),
      };

      if (!group.name || !group.creator) {
        response.status(400).send("Name is required.");
        return;
      }

      try {
        const ref = await admin.firestore().collection("groups").add(group);
        response.send(ref.id);
      } catch (e) {
        response.status(500).send(e);
      }
    });

export const getGroup = functions.https
    .onRequest(async (request, response) => {
      const id = request.query.id as string;
      if (!id || typeof id !== "string") {
        response.status(400).send("ID is required.");
        return;
      }
      try {
        const ref = await admin.firestore().collection("groups").doc(id).get();
        response.send(ref.data());
      } catch (e) {
        response.status(500).send(e);
      }
    });

