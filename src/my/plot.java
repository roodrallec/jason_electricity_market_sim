package my;

import jason.asSemantics.DefaultInternalAction;
import jason.asSemantics.TransitionSystem;
import jason.asSemantics.Unifier;
import jason.asSyntax.NumberTerm;
import jason.asSyntax.Term;
import jason.asSyntax.StringTerm;

import java.util.HashMap;
import java.util.Map;

import javax.swing.JFrame;

import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartFrame;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.plot.PlotOrientation;
import org.jfree.data.xy.DefaultXYDataset;

/** Plot a graph with the score of the players */
public class plot extends DefaultInternalAction {

    static Map<String,HashMap<Integer,Integer>> values = new HashMap<String,HashMap<Integer,Integer>>();

    static DefaultXYDataset dataset = new DefaultXYDataset();
    static {
        JFreeChart xyc = ChartFactory.createXYLineChart(
                             "Network efficiency",
                             "Turn",
                             "Efficiency",
                             dataset, // dataset,
                             PlotOrientation.VERTICAL, // orientation,
                             true, // legend,
                             true, // tooltips,
                             true); // urls

        JFrame frame = new ChartFrame("Electricity Market Simulation", xyc);
        frame.setSize(800,500);
        frame.setVisible(true);
		
		values.put("Production", new HashMap<Integer,Integer>());
	values.put("Potential", new HashMap<Integer,Integer>());
	values.put("Needs", new HashMap<Integer,Integer>());
	values.put("Consumption", new HashMap<Integer,Integer>());
	values.put("OldPrice", new HashMap<Integer,Integer>());
    }

    @Override
    public Object execute(final TransitionSystem ts, final Unifier un, final Term[] args) throws Exception {
        String series  = (String) ((StringTerm)args[0]).getString();
        int step = (int)((NumberTerm)args[1]).solve();
		int score = (int)((NumberTerm)args[2]).solve();
        addValue(series, step, score);
        return true;
    }

    void addValue(String series, int step, int vl) {
		HashMap<Integer,Integer> map = values.get(series);
        map.put(step,vl);
        double[][] data = getData(step, map);
        synchronized (dataset) {
            dataset.addSeries(series, data);
        }
    }

    private double[][] getData(int maxStep, HashMap<Integer,Integer> map) {
        double[][] r = new double[2][maxStep+1];
        int vl = 0;
        for (int step = 0; step<=maxStep; step++) {
            if (map.containsKey(step))
                vl = map.get(step);
            r[0][step] = step;
            r[1][step] = vl;
        }
        return r;
    }
}
