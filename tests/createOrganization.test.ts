const { test, expect } = require("@playwright/test");

test("test", async ({ page, baseURL }) => {
  // Go to http://localhost:3000/login
  await page.goto(`${baseURL}/login`);

  // Click text=Login
  await Promise.all([
    page.waitForNavigation(/*{ url: 'http://localhost:3000/' }*/),
    page.click("text=Login"),
  ]);

  // Click text=Organizations
  await Promise.all([
    page.waitForNavigation(/*{ url: 'http://localhost:3000/organizations' }*/),
    page.click("text=Organizations"),
  ]);

  await Promise.all([
    page.waitForNavigation(/*{ url: 'http://localhost:3003/organizations/create' }*/),
    page.click("text='Create Organization'"),
  ]);
//   expect(page.url()).toBe(`${baseURL}/organizations/create`);

  // Click input
  await page.click("input");

  // Fill input
  await page.fill("input", "Abdellah");

  // Press Tab
  await page.press("input", "Tab");

  // Fill #Email
  await page.fill("#Email", "mail@gmail.bet");

  // Click #Phone
  await page.click("#Phone");

  // Click text=Create Organization
  await Promise.all([
    page.waitForNavigation(/*{ url: 'http://localhost:3000/organizations' }*/),
    page.click("text=Create Organization"),
  ]);

  // Click flash-messages div:has-text("Organization created successfully")
  await expect(
    page.locator(
      'flash-messages:has-text("Organization created successfully")'
    )
  ).toBeVisible();
});
