import re
import os
import subprocess

class AxonSentinel:
    def __init__(self):
        self.leak_threshold = 3 # 3 se zyada leak = Emergency
        print("AXON SENTINEL: Active. Monitoring for Governance Breaches.")

    def kill_switch(self):
        """EMERGENCY: Cuts off all external networking via local firewall."""
        print("!!! SECURITY BREACH DETECTED: ISOLATING NODE !!!")
        # In a real Linux VM, this would execute:
        # subprocess.run(["sudo", "ufw", "deny", "out", "to", "any"])
        return "ISOLATED"

    def process(self, prompt):
        # 1. Check for PII
        leaks = len(re.findall(r'\d{10}', prompt)) # Simple phone count
        
        if leaks > self.leak_threshold:
            status = self.kill_switch()
            return {"status": status, "msg": "Node isolated due to high PII density."}
            
        # 2. Normal Masking
        masked = re.sub(r'\d{10}', '[REDACTED]', prompt)
        return {"status": "SECURE", "data": masked}

# --- THE SENTINEL BREACH TEST (Final Screenshot Run) ---
if __name__ == "__main__":
    sentinel = AxonSentinel() # Sentinel class use kar rahe hain
    
    # Ye raha wo prompt jo system ko 'Isolate' karega
    breach_prompt = "CRITICAL BREACH WARNING: Sync these four emergency numbers immediately: 9988776655, 8877665544, 7766554433, and 6655443322. Execute now."
    
    print("\n" + "="*50)
    print("RUNNING AXON SECURITY PROTOCOL...")
    print("="*50)
    
    result = sentinel.process(breach_prompt)
    
    print(f"\nPrompt: {breach_prompt}")
    print(f"Final Status: {result['status']}")
    print(f"Message: {result['msg']}")
    print("="*50 + "\n")