import { FastifyInstance } from 'fastify';
import { shared } from '@mwd-skeleton/shared';

export default async function (fastify: FastifyInstance) {
  fastify.get('/', async function () {
    return { message: shared() };
  });
}
