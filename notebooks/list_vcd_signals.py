import vcdvcd


def list_vcd_signals(vcd_filename):
    """
    Parse a VCD file and list all signals with their properties
    """
    try:
        # Parse the VCD file
        vcd = vcdvcd.VCDVCD(vcd_filename)

        print(f"VCD File: {vcd_filename}")
        print(f"Timescale: {vcd.timescale}")
        print(f"End time: {vcd.endtime}")
        print("-" * 50)

        # Get all signals
        signals = vcd.references_to_ids.keys()
        print(signals)

        print(f"Total signals found: {len(signals)}")
        print("-" * 50)

        # List each signal with details
        for signal_name in sorted(signals):
            signal_id = vcd.references_to_ids[signal_name]
            signal_data = vcd[signal_name]

            # Get signal size/width
            size = signal_data.size if hasattr(signal_data, "size") else "N/A"

            # Get number of value changes
            num_changes = len(signal_data.tv)

            # Get initial and final values (if available)
            if num_changes > 0:
                initial_val = (
                    signal_data.tv[0][1]
                    if len(signal_data.tv[0]) > 1
                    else "N/A"
                )
                final_val = (
                    signal_data.tv[-1][1]
                    if len(signal_data.tv[-1]) > 1
                    else "N/A"
                )
            else:
                initial_val = final_val = "N/A"

            print(f"Signal: {signal_name}")
            print(f"  ID: {signal_id}")
            print(f"  Size: {size} bits")
            print(f"  Changes: {num_changes}")
            print(f"  Initial value: {initial_val}")
            print(f"  Final value: {final_val}")
            print()

    except FileNotFoundError:
        print(f"Error: VCD file '{vcd_filename}' not found")
    except Exception as e:
        print(f"Error parsing VCD file: {e}")


def list_signals_by_hierarchy(vcd_filename):
    """
    Alternative function to list signals organized by hierarchy
    """
    try:
        vcd = vcdvcd.VCDVCD(vcd_filename)

        print(f"VCD File: {vcd_filename}")
        print("Signals organized by hierarchy:")
        print("-" * 50)

        # Group signals by hierarchy (module path)
        hierarchy = {}

        for signal_name in vcd.references_to_ids.keys():
            # Split signal name by hierarchy separator (usually '.')
            parts = signal_name.split(".")
            if len(parts) > 1:
                module = ".".join(parts[:-1])
                signal = parts[-1]
            else:
                module = "top"
                signal = signal_name

            if module not in hierarchy:
                hierarchy[module] = []
            hierarchy[module].append(signal)

        # Print organized hierarchy
        for module in sorted(hierarchy.keys()):
            print(f"\nModule: {module}")
            for signal in sorted(hierarchy[module]):
                full_name = (
                    f"{module}.{signal}" if module != "top" else signal
                )
                signal_data = vcd[full_name]
                num_changes = len(signal_data.tv)
                print(f"  {signal} ({num_changes} changes)")

    except Exception as e:
        print(f"Error: {e}")


if __name__ == "__main__":
    vcd_file = (
        "notebooks/Chapter_4_examples/example_8__counter_4bit/"
        + "counter_4bit_testbench.vcd"
    )

    print("=== Basic Signal Listing ===")
    list_vcd_signals(vcd_file)

    print("\n" + "=" * 60)
    print("=== Hierarchical Signal Listing ===")
    list_signals_by_hierarchy(vcd_file)
