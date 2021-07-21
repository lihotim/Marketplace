// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Marketplace {
    string public name;
    uint public productCount = 0;
    mapping(uint => Product) public products;

    struct Product {
        uint id;
        string name;
        uint price;
        address payable owner;
        bool purchased;
    }

    event ProductCreated(
        uint id,
        string name,
        uint price,
        address payable owner,
        bool purchased
    );
    
    event ProductPurchased(
        uint id,
        string name,
        uint price,
        address payable owner,
        bool purchased
    );

    constructor() {
        name = "Dapp University Marketplace";
    }

    function createProduct(string memory _name, uint _price) public {
        // Require a valid name
        require(bytes(_name).length > 0);
        // Require a valid price
        require(_price > 0);
        // Increment product count
        productCount ++;
        // Create the product
        products[productCount] = Product(productCount, _name, _price, payable(msg.sender), false);
        // Trigger an event
        emit ProductCreated(productCount, _name, _price, payable(msg.sender), false);
    }
    
    function purchaseProduct(uint _id) public payable{
        // Fetch the product
        Product memory _product = products[_id];
        // Fetch the owner
        address payable _seller = _product.owner;
        // Make sure the procuct has valid id
        require(_product.id > 0 && _product.id <= productCount);
        // Require that there is enough ether in the transaction
        require(msg.value>=_product.price);
        // Require the product has not been purchased
        require(!_product.purchased);
        // Require the buyer is not the seller
        require(_seller != msg.sender);
        // Transfer ownership to the buyer
        _product.owner = payable(msg.sender);
        //Mark as purchased
        _product.purchased = true;
        // Update the product in the mapping
        products[_id] = _product;
        //Pay the seller by sending them ether
        payable(_seller).transfer(msg.value);
        // Trigger event
        emit ProductPurchased(productCount, _product.name, _product.price, payable(msg.sender), true);
    }
    
    

    
    
}








