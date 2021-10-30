export enum Priority {
  LOW = 'LOW',
  MEDIUM = 'MEDIUM',
  HIGH = 'HIGH',
}

export type TaskType = {
  title: string;
  creator: string;
  priority?: Priority;
  assignees?: string[];
  groupId?: string;
  dueDate?: string;
  description?: string;
  createdAt?: string;
  tags?: string[];
}

export type TaskTypeWithID = { id: string } & TaskType;
