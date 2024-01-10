// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/draft-ERC20PermitUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import { Blacklist } from "./common/Blacklist.sol";

contract PHPToken is
    Initializable,
    ERC20Upgradeable,
    ERC20BurnableUpgradeable,
    PausableUpgradeable,
    AccessControlUpgradeable,
    ERC20PermitUpgradeable,
    UUPSUpgradeable,
    Blacklist
{
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    uint256 public constant MAX_ADDRESSES = 100; // Address limit 

    function initialize() external initializer {
        __ERC20_init("PHPToken", "PHPT");
        __ERC20Burnable_init();
        __Pausable_init();
        __AccessControl_init();
        __ERC20Permit_init("PHPToken");
        __UUPSUpgradeable_init();

        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(PAUSER_ROLE, msg.sender);
        _mint(msg.sender, 10000000 * 10**decimals());
        _setupRole(MINTER_ROLE, msg.sender);
        _setupRole(BLACKLIST_ADMIN_ROLE, msg.sender);
    }

    function pause() external onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() external onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    event BlacklistUpdated(address[] accounts, bool added);

    function addBlacklist(address[] memory accounts) external onlyRole(BLACKLIST_ADMIN_ROLE) {
        require(accounts.length <= MAX_ADDRESSES, "Exceeds maximum address limit");
        for (uint256 i = 0; i < accounts.length; i++) {
            _addBlacklist(accounts[i]);
        }
        emit BlacklistUpdated(accounts, true);
    }

    function removeBlacklist(address[] memory accounts) external onlyRole(BLACKLIST_ADMIN_ROLE) {
        require(accounts.length <= MAX_ADDRESSES, "Exceeds maximum address limit");
        for (uint256 i = 0; i < accounts.length; i++) {
            _removeBlacklist(accounts[i]);
        }
        emit BlacklistUpdated(accounts, false);
    }

    function mint(address to, uint256 amount) external onlyRole(MINTER_ROLE) {
        _mint(to, amount);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override whenNotPaused {
        require(!isBlacklist(msg.sender), "PHPToken: caller in blacklist can't transferFrom");
        require(!isBlacklist(from), "PHPToken: from in blacklist can't transfer");
        require(!isBlacklist(to), "PHPToken: not allow to transfer to recipient address in blacklist");
        super._beforeTokenTransfer(from, to, amount);
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyRole(DEFAULT_ADMIN_ROLE) {}
}
