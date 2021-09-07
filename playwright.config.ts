import { PlaywrightTestConfig } from '@playwright/test';
const config: PlaywrightTestConfig = {
  webServer: {
    command: 'npm run start-for-test',
    port: 3003,
    timeout: 120 * 1000,
    reuseExistingServer: !process.env.CI,
  },
  testDir: "./tests"
};
export default config;