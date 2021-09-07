const { test, expect } = require('@playwright/test');

test('test', async ({ page }) => {

  // Go to http://localhost:3003/login
  await page.goto('http://localhost:3003/login');

  // Click text=Login
  await Promise.all([
    page.waitForNavigation(/*{ url: 'http://localhost:3003/' }*/),
    page.click('text=Login')
  ]);

  // Click text=Contacts
  await Promise.all([
    page.waitForNavigation(/*{ url: 'http://localhost:3003/cożntacts' }*/),
    page.click('text=Contacts')
  ]);

  // Click text=CreateContact
  await Promise.all([
    page.waitForNavigation(/*{ url: 'http://localhost:3003/contacts/create' }*/),
    page.click('text=CreateContact')
  ]);
  // await page.pause();
  // Click input
  await page.click('input');

  // Fill input
  await page.fill('input', 'Abdellah');

  // Press Tab
  await page.press('input', 'Tab');

  // Fill [id="Last Name"]
  await page.fill('[id="Last Name"]', 'Alaoui');

  // Press Tab
  await page.press('[id="Last Name"]', 'Tab');

  // Select 871926f207d811ec8ade4f15bde58cd2
  await page.selectOption('text=OrganizationOrganization >> select', {label:'Organization 1'});

  // Click text=Create Contact
  await Promise.all([
    page.waitForNavigation(/*{ url: 'http://localhost:3003/contacts' }*/),
    page.click('text=Create Contact')
  ]);

  // Click flash-messages div:has-text("Contact created successfully")
  await page.click('flash-messages:has-text("Contact created successfully")');

});