import Vapor
import APNS
import APNSCore

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }

    app.post("send-notification") { req async throws -> HTTPStatus in
        struct NotificationRequest: Content {
            var token: String
            var title: String
            var body: String
        }
        
        struct Payload: Codable {
            let acme1: String
            let acme2: Int
        }
    
        let notificationRequest = try req.content.decode(NotificationRequest.self)
        
        let payload = Payload(acme1: "hey", acme2: 2)
            
            let alert = APNSAlertNotification(
                alert: .init(
                    title: .raw(notificationRequest.title),
                    subtitle: .raw(notificationRequest.body)
                ),
                expiration: .immediately,
                priority: .immediately,
                topic: "com.liefransim.couple-telecathic",
                payload: payload,
                sound: .normal(“default”)
            )

            // Send the notification
            try await req.apns.client.sendAlertNotification(
                alert,
                deviceToken: notificationRequest.token
            )
        
        return .ok
    }
}
