#!/usr/bin/env node
const { execSync } = require("child_process");
const path = require("path");
const fs = require("fs");

const BIN = path.join(__dirname, "..", "bin");
const SCRIPTS = ["provider", "provider-gui", "key-failover-proxy"];

try {
  // Make scripts executable
  for (const s of SCRIPTS) {
    const f = path.join(BIN, s);
    if (fs.existsSync(f)) {
      fs.chmodSync(f, 0o755);
      console.log(`  ✓ ${s} (executable)`);
    }
  }

  // Install Python deps
  console.log("  Installing Python dependencies (flask, requests)...");
  try {
    execSync("pip3 install flask requests --user", { stdio: "pipe" });
    console.log("  ✓ Python dependencies installed");
  } catch {
    try {
      execSync("pip install flask requests --user", { stdio: "pipe" });
      console.log("  ✓ Python dependencies installed");
    } catch {
      console.log("  ⚠ Could not install Python deps. Run: pip3 install flask requests");
    }
  }

  console.log("\n  Setup complete! Run: provider --help");
} catch (e) {
  console.error("Postinstall error:", e.message);
}
