import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {TaskTypeNoID} from "./types";
admin.initializeApp();
// Start writing Firebase Functions
// https://firebase.google.com/docs/functions/typescript
//
export const helloWorld = functions.https.onRequest((request, response) => {
  functions.logger.info("Hello logs!", {structuredData: true});
  response.send("Hello from Firebase!");
});

export const createTask = functions.https
    .onRequest(async (request, response) => {
      const {title, description} = request.body;
      const task: TaskTypeNoID = {
        title,
        description,
        createdAt: new Date().toISOString(),
      };
      const ref = await admin.firestore().collection("tasks").add(task);
      response.send(ref.id);
    });

export const getTask = functions.https
    .onRequest(async (request, response) => {
      const id = request.query.id as string;
      const ref = await admin.firestore().collection("tasks").doc(id).get();
      response.send(ref.data());
    }
    );

export const updateTask = functions.https
    .onRequest(async (request, response) => {
      const id = request.query.id as string;
      const {title, description} = request.body;
      const ref = await admin.firestore().collection("tasks").doc(id);
      await ref.update({
        title,
        description,
        updatedAt: new Date().toISOString(),
      });
      response.send("ok");
    }
    );

export const deleteTask = functions.https
    .onRequest(async (request, response) => {
      const id = request.query.id as string;
      const ref = await admin.firestore().collection("tasks").doc(id);
      await ref.delete();
      response.send("ok");
    }
    );

