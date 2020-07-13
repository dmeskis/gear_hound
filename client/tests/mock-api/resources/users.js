const _ = require('lodash')

module.exports = {
  all: [
    {
      id: 1,
      username: 'admin',
      email: 'admin@gearhound.com',
      password: 'password',
      name: 'Vue Master',
    },
    {
      id: 2,
      username: 'user1',
      email: 'user1@gearhound.com',
      password: 'password',
      name: 'User One',
    },
  ].map((user) => {
    return {
      ...user,
      token: `valid-token-for-${user.username}`,
    }
  }),
  authenticate({ username, password }) {
    return new Promise((resolve, reject) => {
      const matchedUser = this.all.find(
        (user) => user.username === username && user.password === password
      )
      if (matchedUser) {
        resolve(this.json(matchedUser))
      } else {
        reject(new Error('Invalid user credentials.'))
      }
    })
  },
  create({ username, email, password}) {
    const matchedUser = this.all.find(
      (user) => user.username === username || user.email === email
    )
    if (matchedUser) {
      reject(new Error('Not Acceptable'))
    } else {
      const user = {
        id: 3,
        username,
        email,
        password,
      }
      resolve(user)
    }
  },
  findBy(propertyName, value) {
    const matchedUser = this.all.find((user) => user[propertyName] === value)
    return this.json(matchedUser)
  },
  json(user) {
    return user && _.omit(user, ['password'])
  },
}
