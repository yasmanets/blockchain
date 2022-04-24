/**
*   Owner               --> 0x2A42F54197b2a18390a138bF0c479AC0ab807372
*   Contract address    --> 0x64d4d0b7be64004ef98a4e63ed6051f497088507
*   MumbaiScan          --> https://mumbai.polygonscan.com/address/0x64d4d0b7be64004ef98a4e63ed6051f497088507
*   Twitter             --> @yasmaniaco
*   Github              --> https://github.com/yasmanets
**/


// SPDX-License-Identifier: MIT
pragma solidity >=0.4.4 <=0.8.0;
pragma experimental ABIEncoderV2;
import "./SafeMath.sol";

// Public methods 
interface IERC20 {
    // Returns the number of existing tokens
    function totalSupply() external view returns (uint256);
    
    // Returns the number of tokens for an address specified by parameter
    function balanceOf(address wallet) external view returns (uint256);

    // Returns the number of tokens that the spender will be able to spend in the name of the owner.
    function allowance(address owner, address spender) external view returns (uint256);

    // Returns a boolean result of the specified operation
    function transfer(address recipient, uint256 amount) external returns (bool);

    // Returns a boolean result of the specified operation
    function transferToCompany(address client, address recipient, uint256 amount) external returns (bool);

    // Returns a boolean with the result of the expense operation
    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

contract ERC20Basic is IERC20 {

    string public constant name ="YAS Token";
    string public constant symbol = "YAS";
    uint8 public constant decimals = 18;

    event Transfer(address indexed from, address indexed to, uint256 tokens);
    event Approval(address indexed owner, address indexed spender, uint256 tokens);

    using SafeMath for uint256;

    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;
    uint256 totalSupply_;
    
    constructor(uint256 _initSupply) {
        totalSupply_ = _initSupply * 10 ** 18;
        balances[msg.sender] = totalSupply_;
    }

    function totalSupply() public override view returns (uint256) {
        return totalSupply_;
    }

    function increaseTotalSupply(uint _amount) public {
        totalSupply_ += _amount;
        balances[msg.sender] += _amount;
    }

    function balanceOf(address _tokenOwner) public override view returns (uint256) {
        return balances[_tokenOwner];
    }

    function allowance(address _owner, address _delegate) public override view returns (uint256) {
        return allowed[_owner][_delegate];
    }

    function transfer(address _recipient, uint256 _tokens) public override returns (bool) {
        require(_tokens <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender].sub(_tokens);
        balances[_recipient] = balances[_recipient].add(_tokens);
        emit Transfer(msg.sender, _recipient, _tokens);
        return true;
    }

    function transferToCompany(address _client, address _recipient, uint256 _tokens) public override returns (bool) {
        require(_tokens <= balances[_client]);
        balances[_client] = balances[_client].sub(_tokens);
        balances[_recipient] = balances[_recipient].add(_tokens);
        emit Transfer(msg.sender, _recipient, _tokens);
        return true;
    }

    function approve(address _delegate, uint256 _tokens) public override returns (bool) {
        allowed[msg.sender][_delegate] = _tokens;
        emit Approval(msg.sender, _delegate, _tokens);
        return true;
    }

    function transferFrom(address _owner, address _buyer, uint256 _tokens) public override returns (bool) {
        require(_tokens <= balances[_owner]);
        require(_tokens <= allowed[_owner][msg.sender]);
        
        balances[_owner] = balances[_owner].sub(_tokens);
        allowed[_owner][msg.sender] = allowed[_owner][msg.sender].sub(_tokens);
        balances[_buyer] = balances[_buyer].add(_tokens);
        emit Transfer(_owner, _buyer, _tokens);

        return true;
    }
}