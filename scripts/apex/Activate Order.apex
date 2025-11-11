// Activate Order
Order order = [SELECT Id, Status FROM Order
    WHERE Id = '801gL00000Tx5PcQAJ'
];
order.Status = 'Activated';
update order;
