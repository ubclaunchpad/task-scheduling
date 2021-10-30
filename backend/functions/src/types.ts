export type TaskType = {
  title: string;
  description?: string;
  createdAt?: string;
  updatedAt?: Date;
}

export type TaskTypeWithID = { id: string } & TaskType;
