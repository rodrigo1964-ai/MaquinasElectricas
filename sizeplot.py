"""
Script to resize the height of a matplotlib figure.
This provides interactive menu-based resizing options for figure and paper positioning.
"""

import matplotlib.pyplot as plt


def sizeplot(fig=None):
    """
    Resize the height of a matplotlib figure interactively.

    Parameters:
    -----------
    fig : matplotlib.figure.Figure, optional
        The figure to resize. If None, uses the current figure.

    Returns:
    --------
    None
    """

    # Get current figure handle
    if fig is None:
        fig = plt.gcf()

    # Get current figure position
    figposition = fig.get_figwidth(), fig.get_figheight()
    print(f'Current figure size: {figposition}')

    # Display menu
    print('\nResize height of figure:')
    print('1. No change')
    print('2. To 2.5 in')
    print('3. To 5 in')
    print('4. To 7.5 in')
    print('5. To 8 in')
    print('6. Custom size')

    try:
        kplot = int(input('Enter your choice (1-6): '))
    except ValueError:
        print('Invalid input. No changes made.')
        return

    if kplot == 1:
        print('Figure size unchanged')
        return
    elif kplot == 2:
        new_width, new_height = 6, 2.5
        window_size = (600, 250)
    elif kplot == 3:
        new_width, new_height = 6, 5
        window_size = (600, 500)
    elif kplot == 4:
        new_width, new_height = 6, 7.5
        window_size = (600, 750)
    elif kplot == 5:
        new_width, new_height = 6, 8
        window_size = (600, 800)
    elif kplot == 6:
        try:
            new_width = float(input('Enter width in inches: '))
            new_height = float(input('Enter height in inches: '))
            window_size = None
        except ValueError:
            print('Invalid input. No changes made.')
            return
    else:
        print('Invalid choice. No changes made.')
        return

    # Set new figure size
    fig.set_size_inches(new_width, new_height)

    # Update window size if specified (for display)
    if window_size is not None:
        # Get the figure manager and set window size
        manager = plt.get_current_fig_manager()
        if manager is not None and hasattr(manager, 'window'):
            try:
                # This works for TkAgg backend
                manager.window.wm_geometry(f"{window_size[0]}x{window_size[1]}")
            except AttributeError:
                # For other backends, we can't easily control window size
                pass

    print(f'Figure size set to: {new_width} x {new_height} inches')
    plt.draw()


def set_figure_size(width, height, fig=None):
    """
    Set figure size programmatically.

    Parameters:
    -----------
    width : float
        Width in inches
    height : float
        Height in inches
    fig : matplotlib.figure.Figure, optional
        The figure to resize. If None, uses the current figure.

    Returns:
    --------
    None
    """
    if fig is None:
        fig = plt.gcf()

    fig.set_size_inches(width, height)
    plt.draw()
    print(f'Figure size set to: {width} x {height} inches')


if __name__ == '__main__':
    print("This module provides figure resizing functionality.")
    print("Usage:")
    print("  - Interactive: sizeplot() or sizeplot(fig)")
    print("  - Programmatic: set_figure_size(width, height) or set_figure_size(width, height, fig)")
    print("\nExample:")
    print("  import matplotlib.pyplot as plt")
    print("  import sizeplot")
    print("  plt.plot([1, 2, 3], [1, 4, 9])")
    print("  sizeplot.sizeplot()  # Interactive resize")
