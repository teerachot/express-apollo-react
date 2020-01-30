const express = require("express")
const { ApolloServer, gql } = require("apollo-server-express")
const { makeExecutableSchema } = require("graphql-tools")
const {importSchema} = require("graphql-import")
const morgan = require("morgan")
const path = require("path")
const cors = require("cors")

const typeDefs =gql(importSchema("./schema.graphql"))
const resolvers = require("./resolver")
const schema = makeExecutableSchema({ typeDefs, resolvers })

const server  = new ApolloServer({schema})

const app = express()
app.use(cors())
app.use(morgan())
app.use(express.json())
app.use(express.static('client/build'))
app.get("/",(req,res)=>{
    res.sendFile(path.resolve(__dirname,'client','build','index.html'))
})

server.applyMiddleware({app})

module.exports = {app, schema, server}
