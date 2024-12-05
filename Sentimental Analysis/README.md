# Sentiment Analysis of Twitter Data: Qatar World Cup 2022

This project analyzes Twitter data to understand public perceptions about women’s dress codes during the 2022 Qatar World Cup. The analysis involves cleaning tweets, applying sentiment analysis, and visualizing emotional tones to uncover insights into social attitudes.

## Key Features

1. **Data Cleaning**:  
   - Removes URLs, hashtags, special characters, and other unwanted text to ensure clean and meaningful data for analysis.

2. **Sentiment Analysis**:  
   - Utilizes the "bing" and "nrc" sentiment lexicons to classify tweets as positive, negative, or neutral.  
   - The NRC lexicon categorizes emotions into a broader range of sentiments, such as joy, anger, sadness, and trust, providing a detailed emotional tone.

3. **Customization**:  
   - Includes custom dictionaries to identify Qatar-specific themes and enhance relevance to the topic.

4. **Tokenization & Stopword Removal**:  
   - Breaks text into individual words (tokens) while removing common stopwords for better sentiment categorization.

5. **Visualization**:  
   - Generates a word cloud to visually represent the most frequently occurring words and their emotional weight.

6. **Data Export**:  
   - Exports processed results into Excel and CSV formats for further analysis or reporting.

## Objectives

The goal of this project is to analyze how global audiences perceive women’s dress codes during the Qatar World Cup, capturing emotions and sentiments expressed on Twitter.

## Results

- A word cloud was generated to highlight the most prominent words and their associated sentiments.  
![Word Cloud](https://github.com/AlexGit-05/NLP/blob/main/Sentimental%20Analysis/word%20cloud.png)

## Technologies & Libraries

- **Programming Language**: R  
- **Libraries**: `tidytext`, `dplyr`, `ggplot2`, `wordcloud`, `tidyr`, and others.  
- **Data**: Twitter data sourced using APIs or downloaded datasets.
