import Fastify from 'fastify';
import { app } from './app/app';
import {awsLambdaFastify} from '@fastify/aws-lambda';

// Instantiate Fastify with some config
const server = Fastify({
  logger: true,
});

// Register your application as a normal plugin.
server.register(app);

const proxy = awsLambdaFastify(server);

export const handler = async (event: unknown, context: never) => proxy(event, context);
