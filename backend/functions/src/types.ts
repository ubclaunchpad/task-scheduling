export type TaskTypeNoID = {
  title: string;
  description?: string;
  createdAt?: string;
  updatedAt?: Date;
}

export type TaskTypeWithID = {
  title: string;
  id: string;
  description?: string;
  createdAt?: string;
  updatedAt?: Date;
}
