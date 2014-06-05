---
title: "The Early Spread of Mass Media Increases the Probability of Civil War: A Research Note"
author:
- name: Justin Murphy
  affiliation: University of Southampton
  email: j.murphy@soton.ac.uk
date: April 2014
abstract: A recent article in *International Organization* suggests that by enhancing
  the soft power of states, the spread of mass media decreases the probability of
  civil war onset. This research note contributes an improvement to the logic
  of that argument (internal consistency) and demonstrates a substantively different
  and improved accounting of the empirical relationship between mass media and civil
  war (internal and external validity).

...









\onehalfspacing

In a recent issue of *International Organization*, Camber Warren argues that the spread of mass media technologies throughout a particular country decreases the probability of observing civil war because, other things equal, mass media technologies increase state strength and therefore deter insurgencies. The reason that technologies such as televisions, radios, and newspapers enhance the state's strength is because they increase the state's normative influence and therefore its power to induce loyalty from citizens. More specifically, mass media technologies increase this "soft power" of the state in two ways.

First, mass media technologies lower the costs of communication in general, for states as well as insurgents. Second, however,mass media technologies increase the normative influence of the state in particular because of economies of scale which are unique to the production of normative influence. Because a media message achieves a larger effect on receivers who believe the message was widely disseminated, the production of normative influence through mass media brings increasing marginal returns for each additional unit of effort, as each additional recipient receiving the message increases the effect of the message on the rest of the receivers. Because the state is inherently a larger-scale producer of symbolic content than potential insurgent groups, Warren argues, higher levels of mass media will be associated with normatively stronger states and therefore lower probabilities of observing civil war.

Grounding this theoretical model in the tradition of figures such as Karl Deutsche and Benedict Anderson who first diagnosed the role of mass media in the rise of modern nationalism, as well as contemporary experimental research on mass-media messaging, Warren's theory stresses the unique effects of mass communications relative to small-scale interpersonal communications. Using state-level data for a large panel of countries from 1945 to 1999, Warren demonstrates that, after controlling for other predictors of civil war, mass media density (televisions, radios, and newspapers per person) is associated with more than a tenfold decrease in the likelihood of observing civil war in a particular country-year.

But if higher levels of mass media density decrease the likelihood of civil war, it is extremely puzzling that in modern history, the international system's most rapid and widespread proliferation of mass media density has coincided with its most dramatic increases in civil war. If mass media density decreases the likelihood of civil war as strongly and robustly as Warren argues, then why has the global proliferation of mass media since 1945 had no appreciable effect in pacifying the global prevalence of civil war?

![Mass Media Density and Civil Wars Globally, 1816-1999](figure/globalplot.pdf) 


The first shortcoming of Warren's argument is that, while there should be increasing marginal returns to the production of normative influence in the context of *mass communications,* there should not be a linear, one-to-one relationship between a country's mass media density and its capacity for mass communications. When only a very small proportion of the population has access to mass media technologies, those technologies do not imply the presence of a mass communications system at merely low levels; they imply a country which still categorically lacks the infrastructural capacity for properly mass communications.^[Of course, there is no way to know *a priori* how many people need access to mass media technologies before they constitute a mass public network and therefore the categorical presence of a mass communications system. In any event, the question is pursued empirically below. At this stage, it suffices simply to note the contention that very low levels of mass media density do not reflect the positive presence of a mass communications capacity.] If only a very small proportion of a population has access to television, radio, or a newspaper, recipients of mass media messaging will know that the vast majority of others will not be affected by the message. Thus, within the subset of countries characterized by very low levels of media density, the normative influence of messages delivered by mass media technologies should not be enhanced by increasing marginal returns as these are contingent on the recipient believing the message to be *widely* spread.

Mass media density only captures the reach of mass communications within a particular country beyond the threshold at which mass media technologies are sufficiently widespread to effectively consititute a mass public network.^[I assume throughout that mass media typically first appears within countries at very low levels relative to the population (low media density). I also assume throughout that, despite variable rates of change and short-run decreases, media density has a long-run tendency to increase. In other words, I assume that the dynamics of media density are non-stationary and trend upward. The Levin-Lin-Chu [-@Levin:2002hu] and Im-Pesaran-Shin [-@Im:2003ba] tests for stationarity in panel data fail to reject the null hypothesis that media density is non-stationary (p = 0.75 and p = 0.1, respectively). See the Appendix for details.]

The second shortcoming is that if the level of mass media *in general* increases state strength as Warren argues, then for this very reason, the *first appearance and early growth* of mass media within a country should increase the utility of controlling the state relative to other means of merely influencing it. Especially given that mass media density is non-stationary and trends upward in every country in which it has been introduced, the first appearance of mass media technology should increase the incentives of opposition groups to risk insurgency before the development of a mass communications system significantly increases the power of the incumbent and decreaes the power of opposition groups outside the state. Additionally, the closer a country's mass media density is to the threshold at which it will constitute a capacity for mass communcations, the more attractive it will be for opposition groups outside the state to gain control of the state. It is increasingly urgent as the state becomes nearer to consolidating its normative domination via mass communications and therefore significantly less vulnerable to insurgency; also, the closer the country is to the threshold the less time will a successful insurgency be vulnerable to yet another insurgency before it consolidates its own normative consolidation via mass communications. Thus, if it is true that increasing mass media density makes state power increasingly safe from insurgency, then before media density crosses the threshold of constituting mass communications power, *each increase* in mass media density should further increase the payoffs to violent insurgency.

This research note advances a different theory of the relationship between mass media technology and civil war: the *introduction and early growth* of mass media density within a country *increases* rather than decreases the likelihood of civil war. Precisely because a capacity for mass communications increases state power and becomes a robust deterrent against insurgents, but low levels of mass media density do not yet constitute that power, year-to-year increases in mass media density up to a certain threshold should be positively associated with civil war onset.^[It stands to reason that the same logic characterizes the incentives of incumbents, as each increase in mass media density up to that threshold also increases the utility of defeating insurgencies relative to stepping down or sharing power, thus further predicting civil war onsets. Yet the calculus of incumbents is likely more complicated given that under certain conditions it could be preferable to share the state's new mass communications power rather than risk losing it. At present, I focus on the calculus of insurgents and leave the calculus of incumbents to future research.] It is only beyond that threshold that Warren's finding of a negative relationship between mass media density and civil war should hold.

To test whether this theory explains the empirical record better than Warren's highly parsimonious theory, I pursue a strategy of increasing causal leverage relative to the original analyses [@king1994designing, 30]. First, I deduce different and more numerous observable implications for my theory, which provide more numerous opportunities for falsification. Second, I increase data-set observations by extending the original sample.[@king1994designing, 30; @brady2004rethinking, 184].


%%%% Front-load emmpirical findings here

%%%% Sketch importance and implications here

%%%% Outline the rest of the article here


# Review Warren, situated by Deutsche and Anderson

# Theory
  - observable implication 1: differenced mdi in lowest subset --> civil war
  - observable implication 2: tv and newspapers larger effect in lowest subset
  - observable implication 3: civil war more likely after 1945 than before

# Analysis

  All models use rare-events logistic regression.^[Traditional logistic regression estimated by maximum-likelihood would likely underestimate the probability of civil war onsets because civil wars begin in relatively very few country-years [@King:2001ta]. There are 119 (2.06%) onsets in the full sample and 63 (3.47%) in the subset of low-MDI country years.]
 
![Violin plot of media density for all civil war onsets](figure/violinplot.pdf) 


\begin{table}[!htbp] \centering 
  \caption{Early Growth of Media Density Compared to Media Density in General} 
  \label{} 
\footnotesize 
\begin{tabular}{@{\extracolsep{5pt}}lccc} 
\\[-1.8ex]\hline \\[-1.8ex] 
 & Warren & \multicolumn{2}{c}{Low MDI} \\ 
\\[-1.8ex] & (1) & (2) & (3)\\ 
\hline \\[-1.8ex] 
 MDI & $-$2.60$^{***}$ &  &  \\ 
  & (0.71) &  &  \\ 
  $\Delta$MDI &  & 0.48$^{**}$ &  \\ 
  &  & (0.24) &  \\ 
  $\Delta$NEWSPAPER &  &  & 1.40$^{*}$ \\ 
  &  &  & (0.75) \\ 
  $\Delta$RADIO &  &  & 0.27 \\ 
  &  &  & (0.31) \\ 
  $\Delta$TV &  &  & 2.10$^{*}$ \\ 
  &  &  & (1.20) \\ 
  GDP PER CAPITA & $-$0.09 & $-$0.56 & $-$0.49 \\ 
  & (0.36) & (0.36) & (0.31) \\ 
  AREA & $-$0.31 & 0.02 & 0.001 \\ 
  & (0.32) & (0.42) & (0.15) \\ 
  MOUNTAINOUS TERRAIN & 0.45$^{*}$ & 0.48 & 0.11 \\ 
  & (0.24) & (0.36) & (0.09) \\ 
  POPULATION & 0.80$^{***}$ & 0.79$^{**}$ & 0.28$^{**}$ \\ 
  & (0.25) & (0.36) & (0.13) \\ 
  OIL EXPORTER & 0.76$^{***}$ & 1.10$^{**}$ & 1.20$^{**}$ \\ 
  & (0.28) & (0.47) & (0.48) \\ 
  DEMOCRACY & 2.70$^{**}$ & 2.60$^{*}$ & 0.23$^{*}$ \\ 
  & (1.10) & (1.30) & (0.12) \\ 
  DEMOCRACY$^2$ & $-$2.50$^{**}$ & $-$2.00 & $-$0.01 \\ 
  & (1.20) & (1.30) & (0.01) \\ 
  ETHNIC FRACTIONALIZATION & 0.11 & $-$0.43 & $-$0.59 \\ 
  & (0.21) & (0.32) & (0.55) \\ 
  RELIGIOUS FRACTIONALIZATION & 0.60$^{***}$ & 0.53 & 1.40$^{*}$ \\ 
  & (0.23) & (0.33) & (0.79) \\ 
  PEACE YEARS & $-$1.90 & $-$2.00 & $-$0.10 \\ 
  & (2.60) & (2.50) & (0.12) \\ 
  SPLINE 1 & $-$0.55 & $-$6.10 & $-$0.002 \\ 
  & (16.00) & (12.00) & (0.003) \\ 
  SPLINE 2 & $-$5.20 & 3.50 & 0.0004 \\ 
  & (18.00) & (14.00) & (0.001) \\ 
  SPLINE 3 & 3.50 & 0.20 & $-$0.0000 \\ 
  & (5.60) & (4.00) & (0.0003) \\ 
  CONSTANT & $-$4.50$^{***}$ & $-$3.80$^{***}$ & $-$9.70$^{***}$ \\ 
  & (0.18) & (0.20) & (1.80) \\ 
 \textit{Observations} & 5,899 & 1,672 & 1,672 \\ 
\textit{Log likelihood} & $-$528.00 & $-$220.00 & $-$218.00 \\ 
\textit{Akaike information criterion} & 1,085.00 & 470.00 & 471.00 \\ 
\hline \\[-1.8ex] 
\textit{Notes:} & \multicolumn{3}{l}{$^{***}$p $<$ .01; $^{**}$p $<$ .05; $^{*}$p $<$ .1} \\ 
\end{tabular} 
\end{table} 



![TV, Democracy, Economic Growth, and Civil Wars Globally, 1816-1999](figure/longrunplot.pdf) 



\begin{table}[!htbp] \centering 
  \caption{Historical Regressions} 
  \label{} 
\footnotesize 
\begin{tabular}{@{\extracolsep{5pt}}lc} 
\\[-1.8ex]\hline \\[-1.8ex] 
\\[-1.8ex] & civil.wars \\ 
\hline \\[-1.8ex] 
 D.GDPPC & 0.40 \\ 
  & (0.30) \\ 
  L.TVLONG & $-$0.33$^{**}$ \\ 
  & (0.13) \\ 
  D.TVLONG & 2.10$^{*}$ \\ 
  & (1.20) \\ 
  L.POLITY2 & $-$0.02 \\ 
  & (0.08) \\ 
  D.POLITY2 & $-$1.10$^{***}$ \\ 
  & (0.22) \\ 
  L.CIVIL.WARS & 0.09$^{***}$ \\ 
  & (0.01) \\ 
  D.CIVIL.WARS & 0.08$^{***}$ \\ 
  & (0.01) \\ 
  YEAR & $-$0.001 \\ 
  & (0.002) \\ 
  WW1 & 0.22$^{**}$ \\ 
  & (0.10) \\ 
  WW2 & 0.17$^{**}$ \\ 
  & (0.08) \\ 
  CONSTANT & 2.00 \\ 
  & (2.70) \\ 
 \textit{Observations} & 181 \\ 
\textit{Log likelihood} & $-$374.00 \\ 
$\theta$ & 195,860.00  (1,973,767.00) \\ 
\textit{Akaike information criterion} & 770.00 \\ 
\hline \\[-1.8ex] 
\textit{Notes:} & \multicolumn{1}{l}{$^{***}$p $<$ .01; $^{**}$p $<$ .05; $^{*}$p $<$ .1} \\ 
\end{tabular} 
\end{table} 


 
![Disaggregated media density and all civil war onsets over time, by country](figure/full_panel_plot.pdf) 


# Conclusion

# Appendix

The Levin-Lin-Chu statistic is a standard test for the presence of a unit root, otherwise known as non-stationarity or integration of order I(1), in a time series variable observed across multiple cross-sectional units. The Im-Pesaran-Shin test is a "second generation" test which is robust to cross-sectional dependence, common in cross-national panel data. For each test, the null hypothesis is the presence of a unit root. Because the tests require balanced panels, they were applied only to the 24 countries with the maximum time-series of 55 years, a subset which still contains significant variation in geography, income, regime type, and other factors. Specifically, the countries in this subset are: Canada, Cuba, Haiti, Dominican Republic, Mexico, Honduras, El Salvador, Nicaragua, Costa Rica, Uruguay, Ireland, Netherlands, Belgium, Luxembourg, France, Switzerland, Hungary, Romania, Finland, Sweden, Norway, Denmark, Afghanistan, China.



	Levin-Lin-Chu Unit-Root Test (ex. var. : Individual Intercepts
	and Trend )

data:  unit$mdi
z.x1 = -0.32, p-value = 0.7473
alternative hypothesis: stationarity


	Pesaran's CIPS test for unit roots

data:  unit$mdi
CIPS test = -2.1, lag order = 2, p-value = 0.1
alternative hypothesis: Stationarity


\pagebreak   
   
   
# References

\setlength{\parindent}{-0.2in}
\setlength{\leftskip}{0.2in}
\setlength{\parskip}{8pt}
\vspace*{-0.2in}
\noindent
