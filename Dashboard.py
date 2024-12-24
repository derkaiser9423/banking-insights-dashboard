#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Jan 24 11:11:12 2024

@author: tin
"""
import dash
from dash import dcc, html
from dash.dependencies import Input, Output
import pandas as pd
import plotly.express as px

# Load the dataset
data = pd.read_csv('bank-full.csv', sep=';')

# Initialize the Dash app
app = dash.Dash(__name__)
app.title = "Banking Insights Dashboard"

# App Layout
app.layout = html.Div([
    html.H1("Banking Insights Dashboard", style={'textAlign': 'center'}),
    
    # Dropdown to select categorical variables for exploration
    html.Div([
        html.Label("Select Categorical Variable:"),
        dcc.Dropdown(
            id='categorical_dropdown',
            options=[{'label': col, 'value': col} for col in ['job', 'marital', 'education', 'housing', 'loan', 'contact', 'poutcome']],
            value='job'
        )
    ], style={'width': '48%', 'display': 'inline-block'}),

    # Age Distribution
    html.Div([
        dcc.Graph(id='age_distribution'),
    ], style={'width': '48%', 'display': 'inline-block'}),

    # Subscription Rate
    html.Div([
        dcc.Graph(id='subscription_rate'),
    ], style={'width': '48%', 'display': 'inline-block'}),

    # Contact Duration vs. Subscription
    html.Div([
        dcc.Graph(id='contact_duration'),
    ], style={'width': '48%', 'display': 'inline-block'}),

    # Monthly Trends
    html.Div([
        dcc.Graph(id='monthly_trends'),
    ], style={'width': '48%', 'display': 'inline-block'})
])

# Callback to update graphs
@app.callback(
    [Output('age_distribution', 'figure'),
     Output('subscription_rate', 'figure'),
     Output('contact_duration', 'figure'),
     Output('monthly_trends', 'figure')],
    [Input('categorical_dropdown', 'value')]
)
def update_graphs(selected_category):
    # Age Distribution
    fig_age = px.histogram(data, x='age', nbins=20, title="Age Distribution",
                           labels={'age': 'Age', 'count': 'Frequency'},
                           color_discrete_sequence=['blue'])

    # Subscription Rate
    fig_subscription = px.bar(data, x='y', title="Subscription Rate",
                               color='y', labels={'y': 'Subscribed', 'count': 'Count'},
                               color_discrete_map={'yes': 'green', 'no': 'red'})

    # Contact Duration vs. Subscription
    fig_duration = px.scatter(data, x='duration', y='y', color='y',
                               title="Contact Duration vs. Subscription",
                               labels={'duration': 'Contact Duration (seconds)', 'y': 'Subscribed'},
                               color_discrete_map={'yes': 'green', 'no': 'red'})

    # Monthly Trends
    fig_monthly = px.bar(data, x='month', color='y', title="Monthly Subscription Trends",
                         labels={'month': 'Month', 'count': 'Count'},
                         barmode='group', color_discrete_map={'yes': 'green', 'no': 'red'})

    return fig_age, fig_subscription, fig_duration, fig_monthly

# Run the app
if __name__ == '__main__':
    app.run_server(debug=True)


