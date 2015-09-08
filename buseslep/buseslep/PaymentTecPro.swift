
import MercadoPagoSDK
import Foundation

public class PaymentTecPro : NSObject {
    
    public var description_ : String!
    public var externalReference : String!
    public var installments : Int = 0
    public var email : String!
    public var paymentMethodId : String!
    public var token : String!
    public var transactionAmount : Double!
    
    public override init() {
        super.init()
    }
    
    public init(description: String, externalReference : String, installments: Int, token: String, paymentMethodId: String, transactionAmount : Double, email:String) {
        self.description_ = description
        self.externalReference = externalReference
        self.installments = installments
        self.token = token
        self.paymentMethodId = paymentMethodId
        self.transactionAmount = transactionAmount
        self.email = email
        
    }
    
    public func toJSONString() -> String {
        let payer:[String:AnyObject] = ["email": self.email]
        let obj:[String:AnyObject] = [
            "description": self.description_ == nil ? JSON.null : self.description_!,
            "external_reference": self.externalReference == nil ? JSON.null : self.externalReference!,
            "installments" : self.installments == 0 ? JSON.null : self.installments,
            "payment_method_id" : self.paymentMethodId == nil ? JSON.null : self.paymentMethodId!,
            "token": self.token == nil ? JSON.null : self.token!,
            "transaction_amount" : self.transactionAmount!,
            "payer" : payer
            
        ]
        return JSON(obj).toString()
    }
    
}