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
import java.nio.file.Paths;
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

    // ================== GET ==================
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
                                    .append("\"title\": \"Đã Thuê\",")
                                    .append("\"start\": \"").append(dates.get(i)[0]).append("\",")
                                    .append("\"end\": \"").append(dates.get(i)[1]).append("T23:59:59\",")
                                    .append("\"color\": \"#dc3545\",")
                                    .append("\"textColor\": \"#ffffff\"")
                                    .append("}");
                            if (i < dates.size() - 1) {
                                jsonBuilder.append(",");
                            }
                        }
                        jsonBuilder.append("]");
                        if (count < unitBookedDates.size() - 1) {
                            jsonBuilder.append(",");
                        }
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
                    boolean canReply = false;
                    if (user != null) {
                        if ("RENTER".equalsIgnoreCase(user.getType())) {
                            ContractDAO contractDAO = new ContractDAO();
                            int contractId = contractDAO.getValidContractId(user.getId(), id);
                            if (contractId != -1) {
                                canFeedback = true;
                            }
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
                request.setAttribute("warehouse", w);
            }
            request.getRequestDispatcher("/Management/warehouse-form.jsp").forward(request, response);
            return;
        }

        // LIST (default)
        List<Warehouse> list = dao.getAll();

        String statusStr = request.getParameter("status");
        if (statusStr != null && !statusStr.isEmpty() && !statusStr.equals("All")) {
            try {
                int status = Integer.parseInt(statusStr);
                list = list.stream()
                        .filter(w -> w.getStatus() == status)
                        .collect(Collectors.toList());
            } catch (NumberFormatException e) {
            }
        }

        Map<Integer, String> imageMap = new HashMap<>();
        WarehouseImageDAO imgDao = new WarehouseImageDAO();
        for (Warehouse w : list) {
            imageMap.put(w.getWarehouseId(), imgDao.getPrimaryImage(w.getWarehouseId()));
        }
        // LIST (default)

        // --- THÊM 4 DÒNG NÀY ĐỂ LẤY SỐ LIỆU CHO STATS CARD ---
        request.setAttribute("totalWarehouses", dao.countTotal());
        request.setAttribute("activeWarehouses", dao.countByStatus(1)); // 1 là trạng thái Active
        request.setAttribute("inactiveWarehouses", dao.countByStatus(0)); // 0 là trạng thái Inactive
        // -----------------------------------------------------

        request.setAttribute("warehouseImages", imageMap);
        request.setAttribute("warehouseList", list);
        request.setAttribute("filterStatus", statusStr);
        request.getRequestDispatcher("Management/warehouse.jsp").forward(request, response);
    }

    // ================== POST ==================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
          if (session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        try {
            // 1. Nhận dữ liệu từ form
            String idStr = request.getParameter("id");
            String name = request.getParameter("name");
            String address = request.getParameter("address");
            String desc = request.getParameter("description");

            int status = 1;
            int typeId = 1;
            double totalArea = 0;
            try {
                totalArea = Double.parseDouble(request.getParameter("totalArea"));
            } catch (Exception e) {
            }
            try {
                status = Integer.parseInt(request.getParameter("status"));
            } catch (Exception e) {
            }
            try {
                typeId = Integer.parseInt(request.getParameter("warehouseTypeId"));
            } catch (Exception e) {
            }

            boolean isEdit = (idStr != null && !idStr.trim().isEmpty());

            // 2. Map vào Object
            Warehouse w = new Warehouse();
            w.setName(name);
            w.setAddress(address);
            w.setDescription(desc);
            w.setStatus(status);
            if (isEdit) {
                w.setWarehouseId(Integer.parseInt(idStr));
            }

            model.WarehouseType type = new model.WarehouseType();
            type.setWarehouseTypeId(typeId);
            w.setWarehouseType(type);
            w.setTotalArea(totalArea);
            // 3. Lấy danh sách file ảnh được upload
            List<Part> fileParts = new ArrayList<>();
            for (Part part : request.getParts()) {
                if ("images".equals(part.getName()) && part.getSize() > 0) {
                    fileParts.add(part);
                }
            }

            // 4. Validate
            String errorMessage = null;

            if (name == null || name.trim().isEmpty()) {
                errorMessage = "Tên kho không được để trống!";
            } else if (address == null || address.trim().isEmpty()) {
                errorMessage = "Địa chỉ không được để trống!";
            } else if (!isEdit && fileParts.isEmpty()) {
                // Chỉ bắt buộc ảnh khi ADD — Edit không cần nếu không muốn thay ảnh
                errorMessage = "Vui lòng tải lên ít nhất 1 ảnh cho kho!";
            } else if (totalArea <= 0) {
                errorMessage = "Vui lòng nhập tổng diện tích của kho (> 0)!";
            } else if (!isEdit && fileParts.isEmpty()) {
                errorMessage = "Vui lòng tải lên ít nhất 1 ảnh cho kho!";
            }

            // Validate từng file ảnh (chỉ chạy khi có file và chưa có lỗi khác)
            if (errorMessage == null && !fileParts.isEmpty()) {
                for (Part filePart : fileParts) {
                    if (filePart.getSize() > 5 * 1024 * 1024) {
                        errorMessage = "Có ảnh dung lượng lớn hơn 5MB! Vui lòng chọn lại.";
                        break;
                    }
                    String submittedFileName = filePart.getSubmittedFileName();
                    if (submittedFileName == null || !submittedFileName.contains(".")) {
                        errorMessage = "File tải lên không hợp lệ!";
                        break;
                    }
                    String ext = submittedFileName
                            .substring(submittedFileName.lastIndexOf(".") + 1)
                            .toLowerCase();
                    if (!ext.equals("jpg") && !ext.equals("jpeg") && !ext.equals("png")) {
                        errorMessage = "Chỉ hỗ trợ file ảnh định dạng .png, .jpg, .jpeg";
                        break;
                    }
                }
            }

            // Nếu có lỗi → trả về form kèm thông báo
            if (errorMessage != null) {
                request.setAttribute("warehouse", w);
                request.setAttribute("errorMessage", errorMessage);
                request.getRequestDispatcher("/Management/warehouse-form.jsp").forward(request, response);
                return;
            }

            // 5. Lưu thông tin kho vào DB
            WarehouseManagementDAO dao = new WarehouseManagementDAO();
            int currentWarehouseId;

            if (isEdit) {
                currentWarehouseId = w.getWarehouseId();
                dao.update(w);
            } else {
                currentWarehouseId = dao.insertReturnId(w);
            }

            // 6. Lưu ảnh vào ổ đĩa và DB (chỉ khi có file upload)
            if (currentWarehouseId > 0 && !fileParts.isEmpty()) {
                String uploadPath = request.getServletContext().getRealPath("/resources/warehouse/image");
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                WarehouseImageDAO imgDao = new WarehouseImageDAO();
                boolean isFirstImage = true;

                for (int i = 0; i < fileParts.size(); i++) {
                    Part filePart = fileParts.get(i);
                    String submittedFileName = filePart.getSubmittedFileName();
                    String uniqueFileName = currentWarehouseId + "_"
                            + System.currentTimeMillis() + "_" + i + "_" + submittedFileName;

                    filePart.write(uploadPath + File.separator + uniqueFileName);

                    WarehouseImage img = new WarehouseImage();
                    img.setImageUrl(uniqueFileName);

                    // ADD: ảnh đầu tiên là primary
                    // EDIT: tất cả ảnh mới thêm đều không phải primary (giữ primary cũ)
                    if (!isEdit && isFirstImage) {
                        img.setPrimary(true);
                        isFirstImage = false;
                    } else {
                        img.setPrimary(false);
                    }

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

            // 7. Redirect về trang detail của warehouse đó
            response.sendRedirect(request.getContextPath() + "/warehouse?action=view&id=" + currentWarehouseId);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/Management/warehouse-form.jsp").forward(request, response);
        }
    }
}
