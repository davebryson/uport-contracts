pragma solidity ^0.4.4;
import "../recovery/RecoveryQuorum.sol";

contract IdentityFactory {
    event IdentityCreated(
        address indexed userKey,
        address proxy,
        address controller,
        address recoveryQuorum);

    mapping(address => address) public senderToProxy;

    //cost ~2.4M gas
    function CreateProxyWithControllerAndRecovery(address userKey, address[] delegates, uint longTimeLock, uint shortTimeLock) {
        Proxy proxy = new Proxy();
        StandardController controller = new StandardController(proxy, userKey, longTimeLock, shortTimeLock);
        proxy.transfer(controller);
        RecoveryQuorum recoveryQuorum = new RecoveryQuorum(controller, delegates);
        controller.changeRecoveryFromRecovery(recoveryQuorum);

        IdentityCreated(userKey, proxy, controller, recoveryQuorum);
        senderToProxy[msg.sender] = proxy;
    }
}
