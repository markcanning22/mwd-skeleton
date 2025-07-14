import { createProjectGraphAsync, writeJsonFile } from '@nx/devkit';
import { createLockFile, createPackageJson } from '@nx/js';
import { writeFileSync } from 'node:fs';

async function main() {
  const projectGraph = await createProjectGraphAsync();

  const projectName: string = process.env['NX_TASK_TARGET_PROJECT'] ?? '';

  if (!projectName) {
    throw new Error('NX_TASK_TARGET_PROJECT environment variable is not set.');
  }

  const packageJson = createPackageJson(projectName, projectGraph, {
    isProduction: true,
    root: projectGraph.nodes[projectName].data.root,
  });

  const lockFile = createLockFile(
    packageJson,
    projectGraph,
    'yarn'
  );

  writeJsonFile(`apps/mwd-skeleton/dist/package.json`, packageJson);

  writeFileSync(`apps/mwd-skeleton/dist/yarn.lock`, lockFile, {
    encoding: 'utf8',
  });

  // @TODO: Temporary fix to allow IO to complete before exiting the process - or it will hang
  await new Promise((resolve) => setTimeout(resolve, 10000));
  process.exit(0);
}

main();
