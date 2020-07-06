/**
 *Deployed on 2019-10-04
 Contract address 0x1d165b6ad214e2944209c656bacf20430e03a931
*/

pragma solidity 0.5.11;

import "https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/d1158ea68c597075a5aec4a77a9c16f061beffd3/contracts/token/ERC20/ERC20.sol";

contract Simba is ERC20 {
    string constant public name = "Simba";
    string constant public symbol = "SIMBA";
    uint8 constant public decimals = 0;
    address private owner;
    address private boss = 0xE9575A0E1373C552afda07e08787307F1FB0C147;
    address private admin = 0x94c2EdCFB686E7AC875CDb5a3bA2578ed01A2eBC;
    uint256 transferFee = 5000;
    uint256 welcomeFee = 50000;
    uint256 goodbyeFee = 50000;
        
    constructor() public {
        owner = msg.sender;
    }
    
    function burn(uint256 amount) public {
        require(amount > goodbyeFee);
        uint256 value = amount.sub(goodbyeFee);
        _transfer(_msgSender(), boss, goodbyeFee);
        _burn(msg.sender, value);
        emit OnBurned(_msgSender(), amount, value, now);
    }
    
    function mint(address customerAddress, uint256 amount) public {
        require(msg.sender == admin);
        require(amount > welcomeFee);
        uint256 value = amount.sub(welcomeFee);
        _mint(boss, welcomeFee);
        _mint(customerAddress, value);
        emit OnMinted(customerAddress, amount, value, now);
    }
    
    function transfer(address recipient, uint256 amount) public returns (bool) {
        require(amount > transferFee);
        uint256 value = amount.sub(transferFee);
        _transfer(_msgSender(), boss, transferFee);
        _transfer(_msgSender(), recipient, value);
        return true;
    }
    
    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
        require(amount > transferFee);
        uint256 value = amount.sub(transferFee);
        _transfer(sender, recipient, value);
        _transfer(sender, boss, transferFee);
        _approve(sender, _msgSender(), allowance(sender, _msgSender()).sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }
    
    function deposeAdmin(address x) public {
        require(msg.sender == owner);
        address former = admin;
        
        admin = x;
        emit OnAdminDeposed(former, x, now);
    }
    
    function setFee(uint256 _welcomeFee, uint256 _goodbyeFee, uint256 _transferFee) public {
        require(_msgSender() == owner);
        
        welcomeFee = _welcomeFee;
        goodbyeFee = _goodbyeFee;
        transferFee = _transferFee;
        
        emit OnFeeSet(welcomeFee, goodbyeFee, transferFee, now);
    }
    
    event OnMinted (
        address indexed customerAddress,
        uint256 amount,
        uint256 value,
        uint256 timestamp
    );
    
    event OnBurned (
        address indexed customerAddress,
        uint256 amount,
        uint256 value,
        uint256 timestamp
    );
    
    event OnAdminDeposed (
        address indexed former,
        address indexed current,
        uint256 timestamp
    );
    
    event OnFeeSet (
        uint256 welcomeFee,
        uint256 goodbyeFee,
        uint256 transferFee,
        uint256 timestamp
    );
}
