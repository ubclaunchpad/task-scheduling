import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {TaskType, TaskTypeWithID} from "./types";
admin.initializeApp();
// Start writing Firebase Functions
// https://firebase.google.com/docs/functions/typescript
//
export const helloWorld = functions.https.onRequest((request, response) => {
  functions.logger.info("Hello logs!", {structuredData: true});
  response.send("Hello from Firebase!");
});

/**
 * On Success: Returns the Task's ID.
 * On Failure: Returns 400 Response (Bad Request).
 *             Returns 500 Response (Internal Server Error) on error.
 */
export const createTask = functions.https
    .onRequest(async (request, response) => {
      const {title, description} = request.body;
      if (!title) {
        response.status(400).send("Title is required.");
        return;
      }
      const task: TaskType = {
        title,
        description,
        createdAt: new Date().toISOString(),
      };
      try {
        const ref = await admin.firestore().collection("tasks").add(task);
        response.send(ref.id);
      } catch (e) {
        response.status(500).send(e);
      }
    });

/**
 * On Success: Returns a Task.
 * On Failure: Returns 400 Response (Bad Request).
 */
export const getTask = functions.https
    .onRequest(async (request, response) => {
      const id = request.query.id as string;
      if (!id || typeof id !== "string") {
        response.status(400).send("ID is required.");
        return;
      }
      try {
        const ref = await admin.firestore().collection("tasks").doc(id).get();
        response.send(ref.data());
      } catch (e) {
        response.status(500).send(e);
      }
    }
    );

/**
 * On Success: Returns all Tasks.
 * On Failure: Returns 400 Response (Bad Request).
 */
export const listTasks = functions.https
    .onRequest(async (request, response) => {
      try {
        const ref = await admin.firestore().collection("tasks").get();
        const tasks: TaskTypeWithID[] = [];
        ref.forEach((doc) => {
          tasks.push(doc.data() as TaskTypeWithID);
        });
        response.send(tasks);
      } catch (e) {
        response.status(500).send(e);
      }
    }
    );

export const updateTask = functions.https
    .onRequest(async (request, response) => {
      const id = request.query.id as string;
      if (!id || typeof id !== "string") {
        response.status(400).send("ID is required.");
        return;
      }
      const {title, description} = request.body;
      try {
        const ref = await admin.firestore().collection("tasks").doc(id);
        const task = await ref.get();
        if (!task.exists) {
          response.status(404).send("Task not found.");
          return;
        }
        await ref.update({
          title,
          description,
          updatedAt: new Date().toISOString(),
        });
        response.send("ok");
      } catch (e) {
        response.status(500).send(e);
      }
    }
    );

export const deleteTask = functions.https
    .onRequest(async (request, response) => {
      const id = request.query.id as string;
      if (!id || typeof id !== "string") {
        response.status(400).send("ID is required.");
        return;
      }
      try {
        const ref = await admin.firestore().collection("tasks").doc(id);
        await ref.delete();
        response.send("ok");
      } catch (e) {
        response.status(500).send(e);
      }
    }
    );


