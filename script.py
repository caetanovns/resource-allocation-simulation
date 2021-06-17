import pyNetLogo
'''
a = [10, 20, 30, 40, 50]
b = [5, 10, 15, 20, 25]
c = [3, 5, 10, 15, 20]
d = [20, 40, 60, 80, 100]
e = [10, 30, 50, 70, 90]

for i in a:
    for j in b:
        for k in c:
            for l in d:
                for m in e:
                    print("{} {} {} {} {}".format(i, j, k, l, m))
'''

netlogo = pyNetLogo.NetLogoLink(gui=True, netlogo_home="/opt/NetLogo-6.1.1-64", netlogo_version="6.1")
netlogo.load_model('main.nlogo')
netlogo.command('setup')
netlogo.repeat_command('go', 500)