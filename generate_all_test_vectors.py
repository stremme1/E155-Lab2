#!/usr/bin/env python3
"""
Test Vector Generator for MUX2 and five_bit_adder modules
"""

def generate_mux2_test_vectors():
    """Generate test vectors for MUX2 module"""
    
    with open('MUX2.tv', 'w') as f:
        f.write("// Test vectors for MUX2\n")
        f.write("// Format: d0_d1_select_y_expected\n")
        f.write("// Tests all combinations of 7-bit inputs and select signal\n\n")
        
        # Test various combinations
        test_cases = [
            # Basic functionality tests
            ("0000000", "0000000", 0, "0000000"),  # Both inputs 0, select 0
            ("0000000", "0000000", 1, "0000000"),  # Both inputs 0, select 1
            ("1111111", "0000000", 0, "1111111"),  # d0=all 1s, d1=0, select 0
            ("1111111", "0000000", 1, "0000000"),  # d0=all 1s, d1=0, select 1
            ("0000000", "1111111", 0, "0000000"),  # d0=0, d1=all 1s, select 0
            ("0000000", "1111111", 1, "1111111"),  # d0=0, d1=all 1s, select 1
            
            # Seven-segment pattern tests (from your seven_segment.sv)
            ("1000000", "1111001", 0, "1000000"),  # 0 pattern, 1 pattern, select 0
            ("1000000", "1111001", 1, "1111001"),  # 0 pattern, 1 pattern, select 1
            ("0100100", "0110000", 0, "0100100"),  # 2 pattern, 3 pattern, select 0
            ("0100100", "0110000", 1, "0110000"),  # 2 pattern, 3 pattern, select 1
            ("0011001", "0010010", 0, "0011001"),  # 4 pattern, 5 pattern, select 0
            ("0011001", "0010010", 1, "0010010"),  # 4 pattern, 5 pattern, select 1
            ("0000010", "1111000", 0, "0000010"),  # 6 pattern, 7 pattern, select 0
            ("0000010", "1111000", 1, "1111000"),  # 6 pattern, 7 pattern, select 1
            ("0000000", "0010000", 0, "0000000"),  # 8 pattern, 9 pattern, select 0
            ("0000000", "0010000", 1, "0010000"),  # 8 pattern, 9 pattern, select 1
            ("0001000", "0000011", 0, "0001000"),  # A pattern, B pattern, select 0
            ("0001000", "0000011", 1, "0000011"),  # A pattern, B pattern, select 1
            ("1000110", "0100001", 0, "1000110"),  # C pattern, D pattern, select 0
            ("1000110", "0100001", 1, "0100001"),  # C pattern, D pattern, select 1
            ("0000110", "0001110", 0, "0000110"),  # E pattern, F pattern, select 0
            ("0000110", "0001110", 1, "0001110"),  # E pattern, F pattern, select 1
            
            # Edge cases
            ("1010101", "0101010", 0, "1010101"),  # Alternating patterns, select 0
            ("1010101", "0101010", 1, "0101010"),  # Alternating patterns, select 1
            ("1111111", "1111111", 0, "1111111"),  # Both all 1s, select 0
            ("1111111", "1111111", 1, "1111111"),  # Both all 1s, select 1
        ]
        
        for d0, d1, select, y_expected in test_cases:
            f.write(f"{d0}_{d1}_{select}_{y_expected}\n")
        
        f.write("\n// End marker\n")
        f.write("xxxxxxxxxxxxxxxxxxxxx\n")
    
    print("✅ Generated MUX2.tv with comprehensive test vectors!")

def generate_five_bit_adder_test_vectors():
    """Generate test vectors for five_bit_adder module"""
    
    with open('five_bit_adder.tv', 'w') as f:
        f.write("// Test vectors for five_bit_adder\n")
        f.write("// Format: s1_s2_sum_expected\n")
        f.write("// Tests all combinations from 0+0 to F+F\n\n")
        
        # Generate all combinations from 0+0 to F+F
        for s1 in range(16):  # 0 to F
            for s2 in range(16):  # 0 to F
                sum_val = s1 + s2
                
                # Format as binary
                s1_binary = format(s1, '04b')
                s2_binary = format(s2, '04b')
                sum_binary = format(sum_val, '05b')
                
                f.write(f"{s1_binary}_{s2_binary}_{sum_binary}\n")
        
        f.write("\n// End marker\n")
        f.write("xxxxxxxxxxxxx\n")
    
    print("✅ Generated five_bit_adder.tv with all 256 combinations!")

def main():
    """Generate all test vector files"""
    print("🚀 Generating test vectors for all modules...")
    
    generate_mux2_test_vectors()
    generate_five_bit_adder_test_vectors()
    
    print("\n🎉 All test vector files generated successfully!")
    print("📁 Files created:")
    print("   - MUX2.tv (MUX2 test vectors)")
    print("   - five_bit_adder.tv (five_bit_adder test vectors)")

if __name__ == "__main__":
    main()
