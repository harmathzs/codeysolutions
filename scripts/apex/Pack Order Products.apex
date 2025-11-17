// Pack Order Products
Order order = [
    SELECT Id, CreatedDate
        ,OrderNumber
        ,TotalAmount    
        ,(SELECT Id
            ,Product2Id
            ,Product2.Name
            ,Quantity
            ,UnitPrice
        FROM OrderItems)
        ,ContractId    
        ,Contract.ContractNumber
        ,AccountId
        ,Account.Name
        ,BillingCountry
        ,BillingState
        ,BillingPostalCode
        ,BillingCity
        ,BillingStreet
        ,ShippingCountry
        ,ShippingState
        ,ShippingPostalCode
        ,ShippingCity
        ,ShippingStreet
    FROM Order
    ORDER BY CreatedDate DESC
    LIMIT 1   
];

System.debug('Order:');
System.debug(order);

String packedJson = JSON.serializePretty(order);
System.debug('Json-packed order:');
System.debug(packedJson);


