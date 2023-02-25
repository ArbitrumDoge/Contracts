/****************************       🚀🚀🚀🚀 
            ,-.                     
            `-'                   
  Arbitrum  /|\  DogeCoin         
             |                  
            / \          
*****************************/

pragma solidity ^0.8.0;

library SafeMath {
	function tryAdd(uint256 a, uint256 b)
		internal
		pure
		returns (bool, uint256)
	{
		unchecked {
			uint256 c = a + b;
			if (c < a) return (false, 0);
			return (true, c);
		}
	}

	function trySub(uint256 a, uint256 b)
		internal
		pure
		returns (bool, uint256)
	{
		unchecked {
			if (b > a) return (false, 0);
			return (true, a - b);
		}
	}

	function tryMul(uint256 a, uint256 b)
		internal
		pure
		returns (bool, uint256)
	{
		unchecked {
			if (a == 0) return (true, 0);
			uint256 c = a * b;
			if (c / a != b) return (false, 0);
			return (true, c);
		}
	}

	function tryDiv(uint256 a, uint256 b)
		internal
		pure
		returns (bool, uint256)
	{
		unchecked {
			if (b == 0) return (false, 0);
			return (true, a / b);
		}
	}

	function tryMod(uint256 a, uint256 b)
		internal
		pure
		returns (bool, uint256)
	{
		unchecked {
			if (b == 0) return (false, 0);
			return (true, a % b);
		}
	}

	function add(uint256 a, uint256 b) internal pure returns (uint256) {
		return a + b;
	}

	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
		return a - b;
	}

	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
		return a * b;
	}

	function div(uint256 a, uint256 b) internal pure returns (uint256) {
		return a / b;
	}

	function mod(uint256 a, uint256 b) internal pure returns (uint256) {
		return a % b;
	}

	function sub(
		uint256 a,
		uint256 b,
		string memory errorMessage
	) internal pure returns (uint256) {
		unchecked {
			require(b <= a, errorMessage);
			return a - b;
		}
	}

	function div(
		uint256 a,
		uint256 b,
		string memory errorMessage
	) internal pure returns (uint256) {
		unchecked {
			require(b > 0, errorMessage);
			return a / b;
		}
	}

	function mod(
		uint256 a,
		uint256 b,
		string memory errorMessage
	) internal pure returns (uint256) {
		unchecked {
			require(b > 0, errorMessage);
			return a % b;
		}
	}
}

pragma solidity ^0.8.0;

interface IERC20 {
	event Transfer(address indexed from, address indexed to, uint256 value);

	event Approval(
		address indexed owner,
		address indexed spender,
		uint256 value
	);

	function totalSupply() external view returns (uint256);

	function balanceOf(address account) external view returns (uint256);

	function transfer(address to, uint256 amount) external returns (bool);

	function allowance(address owner, address spender)
		external
		view
		returns (uint256);

	function approve(address spender, uint256 amount) external returns (bool);

	function transferFrom(
		address from,
		address to,
		uint256 amount
	) external returns (bool);
}

pragma solidity ^0.8.0;

interface IERC20Metadata is IERC20 {
	function name() external view returns (string memory);

	function symbol() external view returns (string memory);

	function decimals() external view returns (uint8);
}

pragma solidity ^0.8.0;

abstract contract Context {
	function _msgSender() internal view virtual returns (address) {
		return msg.sender;
	}

	function _msgData() internal view virtual returns (bytes calldata) {
		return msg.data;
	}
}

pragma solidity ^0.8.0;

contract ERC20 is Context, IERC20, IERC20Metadata {
	mapping(address => uint256) private _balances;

	mapping(address => mapping(address => uint256)) private _allowances;

	uint256 private _totalSupply;

	string private _name;
	string private _symbol;

	constructor(string memory name_, string memory symbol_) {
		_name = name_;
		_symbol = symbol_;
	}

	function name() public view virtual override returns (string memory) {
		return _name;
	}

	function symbol() public view virtual override returns (string memory) {
		return _symbol;
	}

	function decimals() public view virtual override returns (uint8) {
		return 18;
	}

	function totalSupply() public view virtual override returns (uint256) {
		return _totalSupply;
	}

	function balanceOf(address account)
		public
		view
		virtual
		override
		returns (uint256)
	{
		return _balances[account];
	}

	function transfer(address to, uint256 amount)
		public
		virtual
		override
		returns (bool)
	{
		address owner = _msgSender();
		_transfer(owner, to, amount);
		return true;
	}

	function allowance(address owner, address spender)
		public
		view
		virtual
		override
		returns (uint256)
	{
		return _allowances[owner][spender];
	}

	function approve(address spender, uint256 amount)
		public
		virtual
		override
		returns (bool)
	{
		address owner = _msgSender();
		_approve(owner, spender, amount);
		return true;
	}

	function transferFrom(
		address from,
		address to,
		uint256 amount
	) public virtual override returns (bool) {
		address spender = _msgSender();
		_spendAllowance(from, spender, amount);
		_transfer(from, to, amount);
		return true;
	}

	function increaseAllowance(address spender, uint256 addedValue)
		public
		virtual
		returns (bool)
	{
		address owner = _msgSender();
		_approve(owner, spender, allowance(owner, spender) + addedValue);
		return true;
	}

	function decreaseAllowance(address spender, uint256 subtractedValue)
		public
		virtual
		returns (bool)
	{
		address owner = _msgSender();
		uint256 currentAllowance = allowance(owner, spender);
		require(
			currentAllowance >= subtractedValue,
			"ERC20: decreased allowance below zero"
		);
		unchecked {
			_approve(owner, spender, currentAllowance - subtractedValue);
		}

		return true;
	}

	function _transfer(
		address from,
		address to,
		uint256 amount
	) internal virtual {
		require(from != address(0), "ERC20: transfer from the zero address");
		require(to != address(0), "ERC20: transfer to the zero address");

		_beforeTokenTransfer(from, to, amount);

		uint256 fromBalance = _balances[from];
		require(
			fromBalance >= amount,
			"ERC20: transfer amount exceeds balance"
		);
		unchecked {
			_balances[from] = fromBalance - amount;
			_balances[to] += amount;
		}

		emit Transfer(from, to, amount);

		_afterTokenTransfer(from, to, amount);
	}

	function _mint(address account, uint256 amount) internal virtual {
		require(account != address(0), "ERC20: mint to the zero address");

		_beforeTokenTransfer(address(0), account, amount);

		_totalSupply += amount;
		unchecked {
			_balances[account] += amount;
		}
		emit Transfer(address(0), account, amount);

		_afterTokenTransfer(address(0), account, amount);
	}

	function _burn(address account, uint256 amount) internal virtual {
		require(account != address(0), "ERC20: burn from the zero address");

		_beforeTokenTransfer(account, address(0), amount);

		uint256 accountBalance = _balances[account];
		require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
		unchecked {
			_balances[account] = accountBalance - amount;
			_totalSupply -= amount;
		}

		emit Transfer(account, address(0), amount);

		_afterTokenTransfer(account, address(0), amount);
	}

	function _approve(
		address owner,
		address spender,
		uint256 amount
	) internal virtual {
		require(owner != address(0), "ERC20: approve from the zero address");
		require(spender != address(0), "ERC20: approve to the zero address");

		_allowances[owner][spender] = amount;
		emit Approval(owner, spender, amount);
	}

	function _spendAllowance(
		address owner,
		address spender,
		uint256 amount
	) internal virtual {
		uint256 currentAllowance = allowance(owner, spender);
		if (currentAllowance != type(uint256).max) {
			require(
				currentAllowance >= amount,
				"ERC20: insufficient allowance"
			);
			unchecked {
				_approve(owner, spender, currentAllowance - amount);
			}
		}
	}

	function _beforeTokenTransfer(
		address from,
		address to,
		uint256 amount
	) internal virtual {}

	function _afterTokenTransfer(
		address from,
		address to,
		uint256 amount
	) internal virtual {}
}

pragma solidity ^0.8.0;

abstract contract Ownable is Context {
	address private _owner;

	event OwnershipTransferred(
		address indexed previousOwner,
		address indexed newOwner
	);

	constructor() {
		_transferOwnership(_msgSender());
	}

	modifier onlyOwner() {
		_checkOwner();
		_;
	}

	function owner() public view virtual returns (address) {
		return _owner;
	}

	function _checkOwner() internal view virtual {
		require(owner() == _msgSender(), "Ownable: caller is not the owner");
	}

	function renounceOwnership() public virtual onlyOwner {
		_transferOwnership(address(0));
	}

	function transferOwnership(address newOwner) public virtual onlyOwner {
		require(
			newOwner != address(0),
			"Ownable: new owner is the zero address"
		);
		_transferOwnership(newOwner);
	}

	function _transferOwnership(address newOwner) internal virtual {
		address oldOwner = _owner;
		_owner = newOwner;
		emit OwnershipTransferred(oldOwner, newOwner);
	}
}

pragma solidity ^0.8.0;

abstract contract ReentrancyGuard {
	uint256 private constant _NOT_ENTERED = 1;
	uint256 private constant _ENTERED = 2;

	uint256 private _status;

	constructor() {
		_status = _NOT_ENTERED;
	}

	modifier nonReentrant() {
		_nonReentrantBefore();
		_;
		_nonReentrantAfter();
	}

	function _nonReentrantBefore() private {
		require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

		_status = _ENTERED;
	}

	function _nonReentrantAfter() private {
		_status = _NOT_ENTERED;
	}
}

pragma solidity ^0.8.9;

contract ArbDogeSale is Ownable, ReentrancyGuard {
	using SafeMath for uint256;
	struct UserInfo {
		uint256 allocation;
		uint256 contribution;
		bool hasClaimed;
	}
	uint256 public constant MAX_IDO = 40000000000 * 10**18;
	uint256 public constant IDO_LEVEL_0 = 300 * 10**18;
	uint256 public constant IDO_LEVEL_1 = 600 * 10**18;
	uint256 public constant IDO_LEVEL_2 = 1000 * 10**18;
	mapping(address => UserInfo) public userInfo;
	mapping(address => uint256) public purchasedValue;
	mapping(address => uint256) public claimedAmounts;
	uint256 public totalRaised;
	uint256 public totalAllocation;
	uint256 public basePrice = 50000000000;
	ERC20 public arbDoge;
	bool public openIdo;
	bool public idoClosed;
	address public constant SAFE_ADDRESS =
		0x225b959b50536Fd29678030D2E1e0f2f05c75769;
	event Purchased(
		address indexed sender,
		uint256 contribution,
		uint256 allocation
	);
	event Claimed(address indexed sender, uint256 allocation);

	function getCurrPrice() public view returns (uint256 price) {
		if (totalRaised < IDO_LEVEL_0) {
			price = (basePrice * 65) / 100;
		} else if (totalRaised < IDO_LEVEL_1) {
			price = (basePrice * 75) / 100;
		} else if (totalRaised < IDO_LEVEL_2) {
			price = (basePrice * 85) / 100;
		} else {
			price = basePrice * 16;
		}
	}

	function getAlloaction(uint256 contribution)
		public
		view
		returns (uint256 allocation)
	{
		uint256 curPrice = getCurrPrice();
		allocation = (contribution * 10**18) / curPrice;
	}

	function purchase() external payable nonReentrant {
		require(!idoClosed, "SALE_CLOSED");
		require(openIdo, "SALE_NOT_START");
		require(msg.value > 0, "PURCHASE_AMOUNT_INVALID");
		UserInfo storage user = userInfo[msg.sender];
		user.contribution = user.contribution.add(msg.value);
		totalRaised = totalRaised.add(msg.value);

		uint256 allocation = getAlloaction(msg.value);
		require(allocation + totalAllocation <= MAX_IDO, "Exceed_MAX_IDO");
		totalAllocation = totalAllocation.add(allocation);
		user.allocation = user.allocation.add(allocation);
		emit Purchased(_msgSender(), msg.value, allocation);
	}

	function claim() external nonReentrant {
		require(idoClosed, "SALE_NOT_ENDED");

		UserInfo storage user = userInfo[msg.sender];
		require(user.allocation > 0, "ZERO_ALLOCATION");
		require(!user.hasClaimed, "CLAIMED");
		user.hasClaimed = true;
		arbDoge.transfer(_msgSender(), user.allocation);
		emit Claimed(_msgSender(), user.allocation);
	}

	function startSale(address doge, uint256 price) external onlyOwner {
		require(address(doge) != address(0), "DOGE_ADDRESS_INVALID");
		arbDoge = ERC20(doge);
		setBasePrice(price);
		setOpenIdo(true);
	}

	function closeSale() external onlyOwner {
		idoClosed = true;
		setOpenIdo(false);
		arbDoge.transfer(
			0x000000000000000000000000000000000000dEaD,
			MAX_IDO - totalAllocation
		);
	}

	function extractFunds(address token) public onlyOwner {
		if (token == address(0x0)) {
			uint256 ethbalance = address(this).balance;
			(bool success, ) = payable(SAFE_ADDRESS).call{ value: ethbalance }(
				""
			);
			require(success, "FAILED");
			return;
		}
		IERC20 erc20token = IERC20(token);
		uint256 balance = erc20token.balanceOf(address(this));
		erc20token.transfer(SAFE_ADDRESS, balance);
	}

	function setOpenIdo(bool open) public onlyOwner {
		openIdo = open;
	}

	function setBasePrice(uint256 price) public onlyOwner {
		basePrice = price;
	}
}
