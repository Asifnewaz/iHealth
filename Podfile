source 'https://cdn.cocoapods.org/'

platform :ios, '11.0'
use_frameworks!
inhibit_all_warnings!

#link_with 'iHealth', 'iHealthTests'

def iHealthPods
    #SVProgressHUD
    pod 'SVProgressHUD', '~> 2.2.5'
    
    #Realm
    pod 'RealmSwift', '~> 3.20.0'
    
    #Charts
    pod 'XYPieChart', '~> 0.2'
end

target 'iHealth' do
    iHealthPods
end

target 'iHealthTests' do
    iHealthPods
end
