import java.awt.*;
import java.awt.print.*;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import javax.print.*;
import javax.print.attribute.Attribute;
import javax.print.attribute.PrintServiceAttributeSet;

public class Printer implements Printable {

  PGraphics pg;

  public String[] getConnectedPrinterNames() {
    ArrayList<String> connected = new ArrayList<String>();

    try {
      Process lpstat =  Runtime.getRuntime().exec("lpstat -p");
      BufferedReader reader = new BufferedReader(new InputStreamReader(lpstat.getInputStream()));
      String line;
      while ((line = reader.readLine()) != null) {
        // note: this also seems to be true for "offline" printers in OS X
        int pos = line.indexOf(" is idle.");
        if (pos == -1) {
          pos = line.indexOf(" now printing ");
        }
        if (pos != -1) {
          connected.add(line.substring(8, pos));
        }
      }
      reader.close();
    } catch (Exception e) {
    }

    return connected.toArray(new String[connected.size()]);
  }

  public PrintService getPrintService(String printerName) {
    PrintService[] installed = PrinterJob.lookupPrintServices();
    for (int i=0; i < installed.length; i++) {
      PrintServiceAttributeSet attributes = installed[i].getAttributes();
      for (Attribute a : attributes.toArray()) {
        if (a.getName().equals("printer-name") && attributes.get(a.getClass()).toString().equals(printerName)) {
          return installed[i];
        }
      }
    }
    return null;
  }

  public PrintService getPrintService(String[] printerNames) {
    for (int i=0; i < printerNames.length; i++) {
      PrintService found = getPrintService(printerNames[i]);
      if (found != null) {
        return found;
      }
    }
    return null;
  }

  public int print(Graphics g, PageFormat pf, int page) throws
    PrinterException {

    if (0 < page) {
      return NO_SUCH_PAGE;
    }

    // translate to printable area
    g.translate((int)pf.getImageableX(), (int)pf.getImageableY());

    // scale content to 300dpi
    int contentWidth = (int)(pg.width / 3.125);
    int contentHeight = (int)(pg.height / 3.125);
  
    g.drawImage(pg.image,
                (int)(pf.getImageableWidth()/2 - contentWidth / 2),
                (int)(pf.getImageableHeight()/2 - contentHeight / 2),
                contentWidth,
                contentHeight,
                null);

    return PAGE_EXISTS;
  }

  // print the current display window
  public boolean printDialog() {
    return printDialog(g);
  }

  // print a PGraphics object
  public boolean printDialog(PGraphics pg) {
    PrinterJob job = PrinterJob.getPrinterJob();
    this.pg = pg;
    job.setPrintable(this);
    try {
      if (job.printDialog()) {
        job.print();
        return true;
      }
    } catch (PrinterException ex) {
      System.err.println(ex);
    }
    return false;
  }

  // print the current display window on the default printer without a dialog
  public boolean print() {
    return print(g);
  }

  // print a PGraphics object on the default printer without a dialog
  public boolean print(PGraphics pg) {
    PrinterJob job = PrinterJob.getPrinterJob();

    // try to get all connected printers
    String[] connected = getConnectedPrinterNames();
    println("Connected printers: ");
    printArray(connected);
    if (connected.length == 0) {
      System.err.println("No printer connected");
      return false;
    }

    // try to use the first (default) one
    try {
      PrintService printer = getPrintService(connected);
      job.setPrintService(printer);
      println("Using printer: " + printer);
    } catch (PrinterException ex) {
      System.err.println(ex);
      return false;
    }

    this.pg = pg;
    job.setPrintable(this);
    try {
      job.print();
      return true;
    } catch (PrinterException ex) {
      System.err.println(ex);
    }
    return false;
  }
}
