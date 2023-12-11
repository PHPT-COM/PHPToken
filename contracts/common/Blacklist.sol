// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

abstract contract Blacklist is ERC20Upgradeable, AccessControlUpgradeable {
    bytes32 public constant BLACKLIST_ADMIN_ROLE = keccak256("BLACKLIST_ADMIN_ROLE");

    mapping(address => bool) private _blacklist;

    event BlacklistAdded(address indexed account);

    event BlacklistRemoved(address indexed account);

    function isBlacklist(address account) public view returns (bool) {
        return _blacklist[account];
    }

    function addBlacklist(address[] memory accounts) public onlyRole(BLACKLIST_ADMIN_ROLE) {
        for (uint256 i = 0; i < accounts.length; i++) {
            _addBlacklist(accounts[i]);
        }
    }

    function removeBlacklist(address[] memory accounts) public onlyRole(BLACKLIST_ADMIN_ROLE) {
        for (uint256 i = 0; i < accounts.length; i++) {
            _removeBlacklist(accounts[i]);
        }
    }

    function _addBlacklist(address account) internal {
        _blacklist[account] = true;
        emit BlacklistAdded(account);
    }

    function _removeBlacklist(address account) internal {
        _blacklist[account] = false;
        emit BlacklistRemoved(account);
    }
}
