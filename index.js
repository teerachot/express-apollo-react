
const {app,schema,server}  = require("./app")
const http = require("http").createServer(app)
const dovenv = require("dotenv")
// const {SubscriptionServer} = require("subscriptions-transport-ws")
// const { execute, subscribe } = require('graphql');
dovenv.config()

const PORT = process.env.PORT || 5000

server.installSubscriptionHandlers(http);

http.listen(PORT,()=>{
    console.log(`Go to http://localhost:${PORT}/graphql to run queries!`);
    console.log(`🚀 Subscriptions ready at ws://localhost:${PORT}${server.subscriptionsPath}`)

    // new SubscriptionServer({
    //     execute,
    //     subscribe,
    //     schema
        
    // },{
    //     server: http,
    //     path: '/subscriptions'
    // })
})