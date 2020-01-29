const express = require("express")
const { ApolloServer, gql } = require("apollo-server-express")
const { makeExecutableSchema } = require("graphql-tools")
const {importSchema} = require("graphql-import")
const morgan = require("morgan")
const cors = require("cors")


// const notifications = []
// const typeDefs = `
//   type Query { notifications: [Notification] }
//   type Notification { label: String }
//   type Mutation { pushNotification(label: String!): Notification }
// `
const typeDefs =gql(importSchema("./schema.graphql"))
const resolvers = require("./resolver/resolver")
const schema = makeExecutableSchema({ typeDefs, resolvers })

const server  = new ApolloServer({schema})

const app = express()
app.use(cors())
app.use(morgan())
app.use(express.json())
server.applyMiddleware({app})

module.exports = {app, schema, server}
