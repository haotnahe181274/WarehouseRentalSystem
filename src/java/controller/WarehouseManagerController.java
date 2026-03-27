package controller;

import dao.ContractDAO;
import dao.FeedbackDAO;
import dao.FeedbackResponseDAO;
import jakarta.servlet.annotation.MultipartConfig;
import dao.WarehouseImageDAO;
import dao.WarehouseManagementDAO;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.File;
import java.util.HashMap;
import java.util.Map;
import java.util.stream.Collectors;
import model.Feedback;
import model.FeedbackResponse;
import model.StorageUnit;
import model.UserView;
import model.Warehouse;
import model.WarehouseImage;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
@WebServlet(name = "WarehouseController", urlPatterns = {"/warehouse"})
public class WarehouseManagerController extends HttpServlet {

    // ==================== GET ====================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        WarehouseManagementDAO dao = new WarehouseManagementDAO();
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            request.getRequestDispatcher("/Management/warehouse-form.jsp").forward(request, response);
            return;
        }

        if ("view".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                try {
                    int id = Integer.parseInt(idStr);

                    Warehouse w = dao.getWarehouseById(id);
                    List<WarehouseImage> images = dao.getWarehouseImages(id);
                    List<StorageUnit> units = dao.getStorageUnits(id);

                    Map<Integer, List<String[]>> unitBookedDates = dao.getUnitBookedDates(id);
                    StringBuilder jsonBuilder = new StringBuilder("{");
                    int count = 0;
                    for (Map.Entry<Integer, List<String[]>> entry : unitBookedDates.entrySet()) {
                        jsonBuilder.append("\"").append(entry.getKey()).append("\": [");
                        List<String[]> dates = entry.getValue();
                        for (int i = 0; i < dates.size(); i++) {
                            jsonBuilder.append("{")
                                    .append("\"title\": \"Booked\",")
                                    .append("\"start\": \"").append(dates.get(i)[0]).append("\",")
                                    .append("\"end\": \"").append(dates.get(i)[1]).append("T23:59:59\",")
                                    .append("\"color\": \"#dc3545\",")
                                    .append("\"textColor\": \"#ffffff\"")
                                    .append("}");
                            if (i < dates.size() - 1) jsonBuilder.append(",");
                        }
                        jsonBuilder.append("]");
                        if (count < unitBookedDates.size() - 1) jsonBuilder.append(",");
                        count++;
                    }
                    jsonBuilder.append("}");

                    request.setAttribute("unitEventsJson", jsonBuilder.toString().equals("{}") ? "{}" : jsonBuilder.toString());
                    request.setAttribute("w", w);
                    request.setAttribute("images", images);
                    request.setAttribute("units", units);

                    FeedbackDAO feedbackDAO = new FeedbackDAO();
                    List<Feedback> feedbackList = feedbackDAO.getFeedbackByWarehouseId(id);
                    request.setAttribute("feedbackList", feedbackList);
                    request.setAttribute("warehouseId", id);

                    FeedbackResponseDAO responseDAO = new FeedbackResponseDAO();
                    Map<Integer, FeedbackResponse> feedbackResponses = responseDAO.getResponsesByWarehouseId(id);
                    request.setAttribute("feedbackResponses", feedbackResponses);

                    UserView user = (UserView) session.getAttribute("user");
                    boolean canFeedback = false;
                    boolean canReply    = false;
                    if (user != null) {
                        if ("RENTER".equalsIgnoreCase(user.getType())) {
                            ContractDAO contractDAO = new ContractDAO();
                            int contractId = contractDAO.getValidContractId(user.getId(), id);
                            if (contractId != -1) canFeedback = true;
                        }
                        if ("MANAGER".equalsIgnoreCase(user.getRole())
                                || "ADMIN".equalsIgnoreCase(user.getRole())
                                || "Internal".equalsIgnoreCase(user.getType())) {
                            canReply = true;
                        }
                    }
                    request.setAttribute("canFeedback", canFeedback);
                    request.setAttribute("canReply", canReply);

                    request.getRequestDispatcher("/Management/warehouse-detail.jsp").forward(request, response);
                    return;
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }

        if ("edit".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                int id = Integer.parseInt(idStr);
                Warehouse w = dao.getWarehouseById(id);
                List<WarehouseImage> existingImages = dao.getWarehouseImages(id);
                request.setAttribute("warehouse", w);
                request.setAttribute("existingImages", existingImages);
            }
            request.getRequestDispatcher("/Management/warehouse-form.jsp").forward(request, response);
            return;
        }

        // LIST (default) — redirect to login if not authenticated
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<Warehouse> list = dao.getAll();

        String statusStr = request.getParameter("status");
        if (statusStr != null && !statusStr.isEmpty() && !statusStr.equals("All")) {
            try {
                int status = Integer.parseInt(statusStr);
                list = list.stream()
                        .filter(w -> w.getStatus() == status)
                        .collect(Collectors.toList());
            } catch (NumberFormatException e) {}
        }

        Map<Integer, String> imageMap = new HashMap<>();
        WarehouseImageDAO imgDao = new WarehouseImageDAO();
        for (Warehouse w : list) {
            imageMap.put(w.getWarehouseId(), imgDao.getPrimaryImage(w.getWarehouseId()));
        }

        request.setAttribute("totalWarehouses",    dao.countTotal());
        request.setAttribute("activeWarehouses",   dao.countByStatus(1));
        request.setAttribute("inactiveWarehouses", dao.countByStatus(0));
        request.setAttribute("warehouseImages", imageMap);
        request.setAttribute("warehouseList",   list);
        request.setAttribute("filterStatus",    statusStr);
        request.getRequestDispatcher("Management/warehouse.jsp").forward(request, response);
    }

    // ==================== POST ====================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        try {
            // 1. Read form data
            String idStr   = request.getParameter("id");
            String name    = request.getParameter("name");
            String address = request.getParameter("address");
            String desc    = request.getParameter("description");

            int    status      = 1;
            int    typeId      = 1;
            double totalArea   = 0;
            int    pricePerArea = 0;

            try { totalArea    = Double.parseDouble(request.getParameter("totalArea"));   } catch (Exception e) {}
            try { pricePerArea = Integer.parseInt(request.getParameter("pricePerArea"));  } catch (Exception e) {}
            try { status       = Integer.parseInt(request.getParameter("status"));        } catch (Exception e) {}
            try { typeId       = Integer.parseInt(request.getParameter("warehouseTypeId")); } catch (Exception e) {}

            boolean isEdit = (idStr != null && !idStr.trim().isEmpty());

            // 2. Map to Warehouse object
            Warehouse w = new Warehouse();
            w.setName(name);
            w.setAddress(address);
            w.setDescription(desc);
            w.setStatus(status);
            w.setTotalArea(totalArea);
            w.setPricePerArea(pricePerArea);
            if (isEdit) w.setWarehouseId(Integer.parseInt(idStr));

            model.WarehouseType type = new model.WarehouseType();
            type.setWarehouseTypeId(typeId);
            w.setWarehouseType(type);

            // 3. Collect uploaded image files (skip empty parts)
            List<Part> fileParts = new ArrayList<>();
            for (Part part : request.getParts()) {
                if ("images".equals(part.getName()) && part.getSize() > 0) {
                    fileParts.add(part);
                }
            }

            // 4. Validate inputs
            String errorMessage = null;

            if (name == null || name.trim().isEmpty()) {
                errorMessage = "Warehouse name cannot be empty!";
            } else if (address == null || address.trim().isEmpty()) {
                errorMessage = "Address cannot be empty!";
            } else if (totalArea <= 0) {
                errorMessage = "Please enter a valid total area (> 0)!";
            } else if (pricePerArea < 10000) {
                errorMessage = "Price per m² must be at least 10,000 VND!";
            } else if (!isEdit && fileParts.isEmpty()) {
                // Images are required only when adding a new warehouse
                errorMessage = "Please upload at least 1 image!";
            }

            // Validate each uploaded image file
            if (errorMessage == null && !fileParts.isEmpty()) {
                for (Part filePart : fileParts) {
                    if (filePart.getSize() > 5 * 1024 * 1024) {
                        errorMessage = "One or more images exceed 5MB. Please re-select.";
                        break;
                    }
                    String submittedFileName = filePart.getSubmittedFileName();
                    if (submittedFileName == null || !submittedFileName.contains(".")) {
                        errorMessage = "Invalid file uploaded.";
                        break;
                    }
                    String ext = submittedFileName
                            .substring(submittedFileName.lastIndexOf(".") + 1)
                            .toLowerCase();
                    if (!ext.equals("jpg") && !ext.equals("jpeg") && !ext.equals("png")) {
                        errorMessage = "Only .png, .jpg, .jpeg formats are supported.";
                        break;
                    }
                }
            }

            // Return to form with error message if validation fails
            if (errorMessage != null) {
                request.setAttribute("warehouse", w);
                request.setAttribute("errorMessage", errorMessage);
                request.getRequestDispatcher("/Management/warehouse-form.jsp").forward(request, response);
                return;
            }

            // 5. Save warehouse info to DB
            WarehouseManagementDAO dao = new WarehouseManagementDAO();
            int currentWarehouseId;

            if (isEdit) {
                currentWarehouseId = w.getWarehouseId();
                dao.update(w);
            } else {
                currentWarehouseId = dao.insertReturnId(w);
            }

            // 6. Handle image upload
            if (currentWarehouseId > 0 && !fileParts.isEmpty()) {
                String uploadPath = request.getServletContext().getRealPath("/resources/warehouse/image");
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();

                WarehouseImageDAO imgDao = new WarehouseImageDAO();

                if (isEdit) {
                    // EDIT with new images: delete all existing images first, then insert new ones
                    // Step 6a: Get existing images to delete physical files from disk
                    List<WarehouseImage> oldImages = dao.getWarehouseImages(currentWarehouseId);
                    for (WarehouseImage old : oldImages) {
                        File oldFile = new File(uploadPath + File.separator + old.getImageUrl());
                        if (oldFile.exists()) {
                            oldFile.delete();
                        }
                    }
                    // Step 6b: Delete all image records in DB for this warehouse
                    imgDao.deleteAllByWarehouseId(currentWarehouseId);
                }

                // Step 6c: Save new image files to disk and insert records to DB
                for (int i = 0; i < fileParts.size(); i++) {
                    Part filePart = fileParts.get(i);
                    String submittedFileName = filePart.getSubmittedFileName();
                    String uniqueFileName = currentWarehouseId + "_"
                            + System.currentTimeMillis() + "_" + i + "_" + submittedFileName;

                    filePart.write(uploadPath + File.separator + uniqueFileName);

                    WarehouseImage img = new WarehouseImage();
                    img.setImageUrl(uniqueFileName);

                    // First image is set as primary (both for ADD and when replacing images on EDIT)
                    img.setPrimary(i == 0);
                    img.setStatus(1);

                    String ext = submittedFileName
                            .substring(submittedFileName.lastIndexOf(".") + 1)
                            .toLowerCase();
                    img.setImageType(ext);

                    Warehouse linkW = new Warehouse();
                    linkW.setWarehouseId(currentWarehouseId);
                    img.setWarehouse(linkW);

                    imgDao.insertImage(img);
                }
            }
            // If isEdit and no new files uploaded — keep existing images unchanged (do nothing)

            // 7. Redirect to warehouse detail page
            response.sendRedirect(request.getContextPath() + "/warehouse?action=view&id=" + currentWarehouseId);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("warehouse", new Warehouse());
            request.setAttribute("errorMessage", "System error: " + e.getMessage());
            request.getRequestDispatcher("/Management/warehouse-form.jsp").forward(request, response);
        }
    }
}