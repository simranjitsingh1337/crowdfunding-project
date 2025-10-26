import React, { useState, useEffect } from "react";
import { ethers } from "ethers";
import CrowdfundingABI from './CrowdfundingABI.json'; // Add ABI for the contract
import CrowdfundingTokenABI from './CrowdfundingTokenABI.json'; // Add token ABI

const Crowdfunding = ({ crowdfundingAddress, tokenAddress }) => {
  const [provider, setProvider] = useState(null);
  const [signer, setSigner] = useState(null);
  const [userAddress, setUserAddress] = useState("");
  const [contribution, setContribution] = useState("");
  const [goalReached, setGoalReached] = useState(false);

  useEffect(() => {
    const init = async () => {
      const tempProvider = new ethers.providers.Web3Provider(window.ethereum);
      setProvider(tempProvider);
      const tempSigner = tempProvider.getSigner();
      setSigner(tempSigner);
      const address = await tempSigner.getAddress();
      setUserAddress(address);
    };
    init();
  }, []);

  const handleContribute = async () => {
    const token = new ethers.Contract(tokenAddress, CrowdfundingTokenABI, signer);
    const crowdfunding = new ethers.Contract(crowdfundingAddress, CrowdfundingABI, signer);

    const amount = ethers.utils.parseUnits(contribution, 18);
    await token.approve(crowdfundingAddress, amount);
    await crowdfunding.contribute(amount);
  };

  const checkGoalReached = async () => {
    const crowdfunding = new ethers.Contract(crowdfundingAddress, CrowdfundingABI, provider);
    const goalStatus = await crowdfunding.isGoalReached();
    setGoalReached(goalStatus);
  };

  return (
    <div>
      <h1>Crowdfunding Campaign</h1>
      <p>Goal Reached: {goalReached ? "Yes" : "No"}</p>
      <p>Contribute to the campaign</p>
      <input
        type="text"
        value={contribution}
        onChange={(e) => setContribution(e.target.value)}
        placeholder="Amount to contribute"
      />
      <button onClick={handleContribute}>Contribute</button>
      <button onClick={checkGoalReached}>Check if Goal Reached</button>
    </div>
  );
};

export default Crowdfunding;
