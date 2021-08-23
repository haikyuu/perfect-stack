import edgedb from "edgedb";
export async function getUsers() {
  const connection = await edgedb();
  const users = connection.query(`
    SELECT User {first_name, last_name, email, owner}
  `);
  return users;
}
