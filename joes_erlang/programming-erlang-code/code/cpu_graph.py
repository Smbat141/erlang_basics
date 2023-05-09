import pandas as pd
import matplotlib.pyplot as plt

# create some example data
# data = {'x': [i for i in range(1, 33)],
#         'y': [i for i in range(0, 64, 2)],
#         'fib_pmap': [317371, 180896, 169064, 174910, 175076, 227710, 175633, 217592, 184555, 175610, 175566, 176217,
#                      181891, 186242, 173483, 179994, 187246, 172420, 172211, 204896, 171944, 202191, 215700, 181906,
#                      169894, 175097, 171965, 178123, 176546, 177418, 178483, 174375]}
#
# # create a Pandas DataFrame from the data
# df = pd.DataFrame(data)
#
# # plot the x and y data as a line plot
# df.plot(x='x', y='y', kind='line')
#
# # plt.plot(df['x'], df['fib_pmap'], label='fib_map')
# # show the plot
# plt.show()

# Create a sample dataframe with two columns
# data = {
#     'cpu_count': [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28,
#                   29,
#                   30, 31, 32, ],
#     'speedup': [i for i in range(0, 64, 2)],
#     'fib_pmap': [317371, 180896, 169064, 174910, 175076, 227710, 175633, 217592, 184555, 175610, 175566, 176217, 181891,
#                  186242, 173483, 179994, 187246, 172420, 172211, 204896, 171944, 202191, 215700, 181906, 169894, 175097,
#                  171965, 178123, 176546, 177418, 178483, 174375],
#     'sort_pmap': [21006, 13893, 13949, 12809, 11906, 13060, 11986, 13609, 13800, 22585, 27449, 12385, 12017, 15100,
#                   12119,
#                   14113, 13782, 16905, 17784, 14799, 12229, 15061, 14842, 11909, 14728, 13836, 12522, 13408, 13333,
#                   14931,
#                   13650, 12790]}
#
# df = pd.DataFrame(data)
#
# # Plot the two lines on the same graph
# plt.plot(df['cpu_count'], df['speedup'], label='Speedup')
# plt.plot(df['cpu_count'], df['fib_pmap'], label='fib pmap')
# plt.plot(df['cpu_count'], df['sort_pmap'], label='sort pmap')
#
# # Add labels and legend to the graph
# plt.xlabel('Number Of CPUs')
# plt.ylabel('Speedup')
# plt.legend()
#
# # Show the graph
# plt.show()

# 'sort_map': [14390, 15161, 14301, 14822, 14609, 16293, 15646, 14659, 17039, 17681, 22382, 14763, 14545, 14626,
#                  14476,
#                  15036, 16641, 15749, 16220, 21512, 15750, 16429, 16693, 15145, 15047, 15879, 15241, 13869, 14551,
#                  14817,
#                  14870, 14812, ]



import numpy as np

sort_map = np.array([14390, 15161, 14301, 14822, 14609, 16293, 15646, 14659, 17039, 17681, 22382, 14763, 14545, 14626,
                 14476,
                 15036, 16641, 15749, 16220, 21512, 15750, 16429, 16693, 15145, 15047, 15879, 15241, 13869, 14551,
                 14817,
                 14870, 14812])

sort_pmap = np.array([21006, 13893, 13949, 12809, 11906, 13060, 11986, 13609, 13800, 22585, 27449, 12385, 12017, 15100,
                  12119,
                  14113, 13782, 16905, 17784, 14799, 12229, 15061, 14842, 11909, 14728, 13836, 12522, 13408, 13333,
                  14931,
                  13650, 12790])

sort_map_avg_time = np.mean(sort_map)
sort_pmap_avg_time = np.mean(sort_pmap)
print(sort_map_avg_time)
print(sort_pmap_avg_time)
speedup_ratio = sort_map_avg_time / sort_pmap_avg_time
print(f"The speedup ratio is {speedup_ratio:.2f}")
