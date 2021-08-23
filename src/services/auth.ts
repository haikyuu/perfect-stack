import bcrypt from "bcrypt";

export function checkPassword(password: string, hash: string) {
  return bcrypt.compare(password, hash);
}
