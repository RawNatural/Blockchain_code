// SPDX-License-Identifier: MIT

// CustomERC20.sol
pragma solidity ^0.5.0;

contract CustomERC20 {
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    uint256 private _totalSupply;

    bool private _notEntered;

    address private _appAddress;

    address public contractOwner;


string public name;
    string public symbol;

    constructor(string memory _name, string memory _symbol) public {
        name = _name;
        symbol = _symbol;

        //reentrancy guard
        _notEntered = true;

        _appAddress = msg.sender; // Just for initialisation purposes
        contractOwner = msg.sender;
    }

    modifier nonReentrant() {
        require(_notEntered, "ReentrancyGuard: reentrant call");
        _notEntered = false;
        _;
        _notEntered = true;
    }

    modifier onlyOwner() {
        require(msg.sender == contractOwner, "Only the owner can call this function");
        _;
    }

    modifier onlyApp() {
        require(msg.sender == _appAddress, "Only callable from within app");
        _;
    }


    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public  returns (bool) {
    _transfer(msg.sender, recipient, amount);
    return true;
    }

    function mint(address account, uint256 amount) public onlyApp {
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public  returns (bool) {
        require(_allowances[sender][msg.sender] >= amount, "ERC20: allowance exceeded");

        _transfer(sender, recipient, amount);
        _approve(sender, msg.sender, _allowances[sender][msg.sender] - amount);
        return true;
    }

    function _transfer(address sender, address recipient, uint256 amount) nonReentrant internal {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        require(_balances[sender] >= amount, "ERC20: insufficient balance");

        _balances[sender] -= amount;
        _balances[recipient] += amount;
        emit Transfer(sender, recipient, amount);
    }

    function _approve(address owner, address spender, uint256 amount) nonReentrant internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }

    function setAppAddress(address _appAddy) public onlyOwner {
        _appAddress = _appAddy;
    }

    // Events
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}
