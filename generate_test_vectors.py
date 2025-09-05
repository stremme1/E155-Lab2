#!/usr/bin/env python3
"""
Test Vector Generator for Lab2_ES
Generates all combinations from 0+0 to F+F with both select states
"""

# Seven-segment patterns for hex digits 0-F
seg_patterns = {
    0:  '1000000',  # 0
    1:  '1111001',  # 1
    2:  '0100100',  # 2
    3:  '0110000',  # 3
    4:  '0011001',  # 4
    5:  '0010010',  # 5
    6:  '0000010',  # 6
    7:  '1111000',  # 7
    8:  '0000000',  # 8
    9:  '0010000',  # 9
    10: '0001000',  # A
    11: '0000011',  # B
    12: '1000110',  # C
    13: '0100001',  # D
    14: '0000110',  # E
    15: '0001110'   # F
}

def generate_test_vectors():
    """Generate all test vectors for Lab2_ES"""
    
    # Open output file
    with open('Lab2_ES_tb.tv', 'w') as f:
        # Write header
        f.write("// Test vectors for Lab2_ES\n")
        f.write("// Format: s0_s1_seg_expected_select_led_led_expected\n")
        f.write("// Complete test coverage: all combinations from 0+0 to F+F\n\n")
        
        # Generate all combinations
        for s0 in range(16):  # 0 to F
            f.write(f"// s0={s0:X} combinations\n")
            
            for s1 in range(16):  # 0 to F
                # Calculate sum
                sum_val = s0 + s1
                
                # Get seven-segment patterns
                seg0_pattern = seg_patterns[s0]
                seg1_pattern = seg_patterns[s1]
                
                # Format as 5-bit binary
                led_binary = format(sum_val, '05b')
                
                # Format inputs as 4-bit binary
                s0_binary = format(s0, '04b')
                s1_binary = format(s1, '04b')
                
                # Test case 1: select=0 (show s0)
                f.write(f"{s0_binary}_{s1_binary}_{seg0_pattern}_0_{led_binary}_{led_binary}\n")
                
                # Test case 2: select=1 (show s1)
                f.write(f"{s0_binary}_{s1_binary}_{seg1_pattern}_1_{led_binary}_{led_binary}\n")
            
            f.write("\n")
        
        # Write end marker
        f.write("// End marker\n")
        f.write("xxxxxxxxxxxxxxxxxxxxxxxxx\n")
    
    print("✅ Generated Lab2_ES_tb.tv with all 512 test vectors!")
    print("📊 Coverage: 16×16 combinations × 2 select states = 512 total vectors")

if __name__ == "__main__":
    generate_test_vectors()
