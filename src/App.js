import React from "react";
import Crowdfunding from "./Crowdfunding";

function App() {
  const crowdfundingAddress = "<your-crowdfunding-contract-address>";
  const tokenAddress = "<your-token-contract-address>";
  
  return (
    <div className="App">
      <Crowdfunding crowdfundingAddress={crowdfundingAddress} tokenAddress={tokenAddress} />
    </div>
  );
}

export default App;
