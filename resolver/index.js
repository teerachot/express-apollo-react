const { PubSub } = require("apollo-server-express")

const notifications = []
const pubsub = new PubSub()
const NOTIFICATION_SUBSCRIPTION_TOPIC = "newNotifications"
const NOTIFICATION_SUBSCRIPTION_RUNCODE = "NOTIFICATION_SUBSCRIPTION_RUNCODE"

// F
const FollowerUserNon = ["aek", "aoi", "jin"]
const FollowerUserAek = ["non", "aoi", "jin", "gift"]
const FollowerUserAoi = ["non", "aek", "jin"]

const findFollowing = id => {
	switch (id) {
		case "non":
			return FollowerUserNon
		case "aek":
			return FollowerUserAek
		case "aoi":
			return FollowerUserAoi
	}
}

const Query = {
	notifications: () => notifications
}

const Mutation = {
	pushNotification: (root, args) => {
		const newNotification = { label: args.label, from: args.id }
		notifications.push(newNotification)
		if (args && args.id) {
			const send2user = findFollowing(args.id)

			send2user.forEach(data_id => {
				pubsub.publish(`${NOTIFICATION_SUBSCRIPTION_TOPIC}_${data_id}`, {
					newNotification
				})
			})
		}
		return newNotification
	},
	// runCode: (root, args) => {
	// 	// todo call R engine
	// 	return "HI"
	// }
}

const Subscription = {
	newNotification: {
		subscribe: (root, args) => {
			// who are you

			return pubsub.asyncIterator(
				`${NOTIFICATION_SUBSCRIPTION_TOPIC}_${args.id}`
			)
		}
	}
}

module.exports = {
	Query,
	Mutation,
	Subscription
}
