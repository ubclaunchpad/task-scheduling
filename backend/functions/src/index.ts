import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {GroupType} from "./types";
import { TaskType, TaskTypeWithID } from "./types";
admin.initializeApp();
admin.firestore().settings({
  ignoreUndefinedProperties: true,
});

// Start writing Firebase Functions
// https://firebase.google.com/docs/functions/typescript
//
export const helloWorld = functions.https.onRequest((request, response) => {
  functions.logger.info("Hello logs!", { structuredData: true });
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

export const updateGroup = functions.https
    .onRequest(async (request, response) => {
      const id = request.query.id as string;
      if (!id || typeof id !== "string") {
        response.status(400).send("ID is required.");
        return;
      }
      const group = getGroupFromRequest(request);
      try {
        const ref = await admin.firestore().collection("groups").doc(id);
        const exists = await (await ref.get()).exists;
        if (!exists) {
          response.status(404).send("Group not found.");
          return;
        }
        await ref.update(
            group
        );
        response.send("Group updated!");
      } catch (e) {
        response.status(500).send(e);
      }
    }
    );

/**
 * On Success: Returns the Task's ID.
 * On Failure: Returns 400 Response (Bad Request).
 *             Returns 500 Response (Internal Server Error) on error.
 */

const getTaskFromRequest = (request: functions.Request): TaskType => {
  const { title, description, dueDate, priority, groupId, creator, createdAt } =
    request.body;
  const task: TaskType = {
    title,
    creator,
    description,
    dueDate,
    priority,
    groupId,
    createdAt,
  };
  return task;
};
export const createTask = functions.https.onRequest(
  async (request, response) => {
    const task = {
      ...getTaskFromRequest(request),
      createdAt: new Date().toISOString(),
    };

    if (!task.title || !task.creator) {
      response.status(400).send("Title is required.");
      return;
    }

    try {
      const ref = await admin.firestore().collection("tasks").add(task);
      response.send(ref.id);
    } catch (e) {
      response.status(500).send(e);
    }
  }
);

/**
 * On Success: Returns a Task.
 * On Failure: Returns 400 Response (Bad Request).
 */
export const getTask = functions.https.onRequest(async (request, response) => {
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
});

/**
 * On Success: Returns all Tasks.
 * On Failure: Returns 400 Response (Bad Request).
 */
export const listTasks = functions.https.onRequest(
  async (request, response) => {
    try {
      const ref = await admin.firestore().collection("tasks").get();
      const tasks: TaskTypeWithID[] = [];
      ref.forEach((doc) => {
        tasks.push({ ...doc.data(), id: doc.id } as TaskTypeWithID);
      });
      response.send(tasks);
    } catch (e) {
      response.status(500).send(e);
    }
  }
);

export const updateTask = functions.https.onRequest(
  async (request, response) => {
    const id = request.query.id as string;
    if (!id || typeof id !== "string") {
      response.status(400).send("ID is required.");
      return;
    }
    const task = getTaskFromRequest(request);
    try {
      const ref = await admin.firestore().collection("tasks").doc(id);
      const exists = await (await ref.get()).exists;
      if (!exists) {
        response.status(404).send("Task not found.");
        return;
      }
      await ref.update(task);
      response.send("ok");
    } catch (e) {
      response.status(500).send(e);
    }
  }
);

export const deleteTask = functions.https.onRequest(
  async (request, response) => {
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
