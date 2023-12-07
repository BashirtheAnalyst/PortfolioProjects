#!/usr/bin/env python
# coding: utf-8

# In[1]:


1+3


# In[2]:


import pandas as pd
import numpy as np


# In[4]:


# Pandas Series
g7_pop = pd.Series([35.467, 63.951, 80.940, 60.665, 127.061, 64.511, 318.523])


# In[5]:


g7_pop


# In[7]:


g7_pop.name = 'G7 population in millions'


# In[8]:


g7_pop


# In[9]:


g7_pop.dtype


# In[10]:


g7_pop.values


# In[11]:


g7_pop[0]


# In[12]:


g7_pop[3]


# In[13]:


g7_pop.index


# In[15]:


# Mdofying the index of Series
g7_pop.index = [
    'Canada',
    'France',
    'Germany',
    'Italy',
    'Japan',
    'United Kingdom',
    'United States'
]


# In[16]:


g7_pop


# In[17]:


g7_pop['United States']


# In[18]:


g7_pop.iloc[-1]


# In[19]:


g7_pop > 70


# In[20]:


g7_pop[g7_pop > 70]


# In[21]:


g7_pop[(g7_pop > g7_pop.mean() - g7_pop.std()/2) | (g7_pop > g7_pop.mean() + g7_pop.std()/2)]


# In[22]:


g7_pop[(g7_pop > 80) & (g7_pop < 200)]


# In[23]:


# modifying Series
g7_pop['Canada'] = 40.5
g7_pop


# In[ ]:


# Panda dataFrame


# In[28]:


df = pd.DataFrame({
    'Population': [ 35.467, 63.951, 80.94, 60.665, 127.061, 64.511, 318.523],
    'GDP': [1785387,
           2833687,
           3874954,
           2168796,
           4943049,
           2950095,
           17348075
    ],
    'Surface Area': [
        9984670,
        640679,
        357114,
        301336,
        377930,
        242495,
        9525067
    ],
    'HDI': [
        0.913,
        0.888,
        0.916,
        0.873,
        0.891,
        0.907,
        0.915
    ],
    'Continent': [
        'America',
        'Europe',
        'Europe',
        'Europe',
        'Asia',
        'Europe',
        'America'
    ]
}, columns= ['Population', 'GDP', 'Surface Area', 'HDI', 'Continent']) # The column attribute is optional


# In[29]:


df


# In[30]:


df.index =[
    'Canada',
    'France',
    'Germany',
    'Italy',
    'Japan',
    'United Kingdom',
    'United State'
]


# In[31]:


df


# In[32]:


df.columns


# In[33]:


df.info()


# In[34]:


df.describe()


# In[134]:


df['Canada']


# In[35]:


# Checking Canada data
df.loc['Canada']


# In[36]:


# checking data of the last index
df.iloc[-1]


# In[37]:


#Checking data for population column
df['Population']


# In[38]:


# Getting data from France to Italy
df.loc ['France': 'Italy']


# In[39]:


#Getting only the population values from france to italy
df.loc ['France': 'Italy', 'Population']


# In[40]:


#Getting only the population and GDP values from france to italy
df.loc ['France': 'Italy', ['Population', 'GDP']]


# In[42]:


df.drop(['Canada', 'Japan'])


# In[44]:


df.drop(columns=['Population', 'HDI'])


# In[47]:


# Modifying Dataframe; Adding new column
lang = pd.Series(
['French', 'German', 'Italian'],
index=['France', 'Germany', 'Italy'],
name= 'Language')


# In[138]:


df['Language'] = lang


# In[49]:


df


# In[51]:


# Changing language column to English
df['Language'] = 'English'
df


# In[52]:


#Renaming Column
df.rename(columns={
    'HDI' : 'Human Development Index'
}, index={'United State': 'USA',
         'United Kingdom': 'UK',
         'Argentina': 'AR'}
    )


# In[58]:


# Creating new colums from existing one
df['GDP Per Capita'] = df['GDP'] / df['Population']
df


# In[ ]:


df.head()


# In[ ]:


df.describe()


# In[59]:


population = df['Population']


# In[61]:


population.min(), population.max(), population.sum(), population.mean(), population.describe()


# In[63]:


import matplotlib.pyplot as plt
get_ipython().run_line_magic('matplotlib', 'inline')


# In[70]:


daf = pd.read_csv('C:/Users/Bashir/Desktop/btc-market-price.csv')


# In[71]:


daf


# In[72]:


daf.head()


# In[73]:


# Since no header in the file
daf = pd.read_csv('C:/Users/Bashir/Desktop/btc-market-price.csv', header=None)


# In[75]:


#Now adding column names; i.e header
daf.columns =['Timestamp', 'Price']
daf.head()


# In[76]:


daf.tail()


# In[78]:


daf.dtypes


# In[79]:


# changing the Timestamp from string to date
pd.to_datetime(daf['Timestamp'])


# In[81]:


daf['Timestamp'] = pd.to_datetime(daf['Timestamp'])
daf


# In[82]:


# Setting index to Timestamp
daf.set_index('Timestamp', inplace=True)


# In[83]:


daf.head()


# In[84]:


daf.loc['2017-04-06']


# In[86]:


#Plotting
daf.plot()


# In[87]:


# Handling Missing Data
pd.isnull(None)


# In[88]:


pd.isnull(3)


# In[89]:


pd.notnull(pd.Series([1, np.nan, 8]))


# In[90]:


pd.Series([1, 3, np.nan, 8]).count()


# In[91]:


pd.Series([1, 3, np.nan, 8]).sum()


# In[93]:


s =pd.Series([3, 7, np.nan, 5, np.nan])
s


# In[95]:


#Removing Na values
s.dropna()


# In[ ]:





# In[96]:


#replace na with 0
s.fillna(0)


# In[99]:


d = pd.DataFrame({
    'Column A': [1, np.nan, 30, np.nan],
    'Column B': [2, 8, 31, np.nan],
    'Column C': [np.nan, 9, 32, 100],
    'Column D': [5, 8, 34, 110]
})


# In[100]:


d


# In[102]:


# Filling null value in a dataframe
d.fillna({'Column A': 0, 'Column B': 99, 'Column C': d['Column C'].mean()})


# In[104]:


pd.isnull(d)


# In[106]:


sd = pd.DataFrame({
    'Sex': ['M', 'F', 'F', 'D', '?'],
    'Age': [29, 45, 24, 180, 30]
})


# In[107]:


sd


# In[108]:


sd['Sex'].unique()


# In[109]:


sd['Sex'].value_counts()


# In[110]:


# Replacing D with F
sd['Sex'].replace('D', 'F')


# In[111]:


#Replacing D with F and N with M
sd['Sex'].replace({'D': 'F', 'N': 'M'})


# In[112]:


sd.replace({
    'Sex': {
        'D': 'F',
        'N': 'M'
    },
    'Age': {
        290: 29
    }
})


# In[115]:


# If age is > 100, then divide the age by 10
sd.loc[sd['Age'] > 100, 'Age'] = sd.loc[sd['Age'] > 100, 'Age'] / 10


# In[116]:


sd


# In[118]:


sp =pd.Series([3, 7, np.nan, 5, 7, np.nan])


# In[120]:


# Finding duplicate values
sp.duplicated()


# In[121]:


sp.drop_duplicates()# Removing duplicate values


# In[123]:


sp.drop_duplicates(keep='last')


# In[127]:


dup_in_df = pd.DataFrame({
    'Sex': ['M', 'F', 'F', 'D', 'M'],
    'Age': [29, 45, 24, 180, 29]
})


# In[128]:


dup_in_df


# In[129]:


dup_in_df.duplicated()


# In[130]:


# Checking duplicate only in one column
dup_in_df.duplicated(subset=['Age'])


# In[131]:


dat = pd.DataFrame({
    'Data': [
        '1987_M_US_1',
        '1990?_M_UK_1',
        '1992_F_US_2',
        '1970?_M_   IT_1',
        '1985_F_I  T_2'
    ]
})


# In[132]:


dat


# In[140]:


dat['Data'].str.split('_', expand=True)


# In[141]:


dat = dat['Data'].str.split('_', expand=True)


# In[142]:


dat.columns = ['Year', 'Sex', 'Country', 'No_of_Children']


# In[143]:


dat


# In[144]:


dat['Year'].str.contains('\?')


# In[145]:


# Removing the ? in the year column
dat['Year'].str.strip('\?')


# In[146]:


dat['Country'].str.contains(' ')


# In[154]:


#Removing the space
dm = dat['Country'].str.strip(' ')


# In[156]:


dm.str.contains(' ')


# In[159]:


#Using replace function to remove space
dm = dat['Country'].str.replace(' ', '')


# In[160]:


dm


# In[161]:


# Checking if the space has been removed
dm.str.contains(' ')

