import pandas as pd
'''
approaches = ['best', 'random', 'ga']

for i in approaches:
    try:
        read_file = pd.read_csv("../data/" + i + ".txt", sep=" ",
                                names=['undefined', 'approach', 'tasks', 'workers', 'skills', 'sprints', 'files',
                                       'mean', 'var',
                                       'median', 'max', 'min'])

        read_file = read_file.drop('undefined', axis=1)

        read_file.to_csv("../data/csv/" + i + ".csv", index=False)
    except:
        pass
'''

read = pd.read_csv('../data/csv/case_20.csv')
print(read.head(10))
