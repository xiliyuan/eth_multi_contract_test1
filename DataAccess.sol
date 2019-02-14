pragma solidity ^0.4.24;


contract Owned {

    address public owner;

    constructor () public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    function setOwner(address _newOwner) onlyOwner public {
        owner = _newOwner;
    }
}

contract DataAccess {
    /* struct for a new request */
    struct Request {
        address addr;
        string  encryptCode;
        string  dataURL;
        string  dataHash;
        bool    isApproved;
        uint    timeStamp;
        address dataOwner;
    }

    /* store all data requests */
    Request[] public dataReqPool;

    function sendDataRequest(address dataOwner, string encryptCode)
        public returns (uint index) {
        require(bytes(encryptCode).length > 0);
        dataReqPool.push(Request(msg.sender, encryptCode, "", "", false, now, dataOwner));
        return dataReqPool.length - 1;
    }
    
    function approveDataRequest(uint index, string dataURL, string dataHash)
        public {
        require(index < dataReqPool.length,
                "Invalid index");
        require(!dataReqPool[index].isApproved,
                "Request approved");
        require(msg.sender == dataReqPool[index].dataOwner,
                "Not data owner");
        require(bytes(dataURL).length > 0);
        require(bytes(dataHash).length > 0);
        
        dataReqPool[index].dataURL = dataURL;
        dataReqPool[index].dataHash = dataHash;
        dataReqPool[index].isApproved = true;
        dataReqPool[index].timeStamp = now;
    }

    function getRequestCount()
        public view returns (uint count) {
        return dataReqPool.length;
    }
}