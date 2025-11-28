package dao;

import conexion.Conexion;
import entity.Producto;
import java.sql.*;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class ProductoDAO {
    
    public List<Producto> getProductos() {
        Conexion conn = new Conexion();
        Connection conexion = null;
        List<Producto> productos = new ArrayList<>();
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conexion = conn.getConexion();
            String query = "SELECT * FROM tablas.producto ORDER BY id_producto ASC";//Verificar si va ORDER BY
            ps = conexion.prepareStatement(query);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Producto producto = new Producto(
                    rs.getInt("id_producto"),
                    rs.getString("nombre"),
                    rs.getBigDecimal("precio_venta"),
                    rs.getInt("stock")
                );
                productos.add(producto);
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error " + e.toString());
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conexion != null) conexion.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar recursos " + e.toString());
            }
        }
        return productos;
    }
    
    public List<Producto> getProductosConStock() {
        Conexion conn = new Conexion();
        Connection conexion = null;
        List<Producto> productos = new ArrayList<>();
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conexion = conn.getConexion();
            String query = "SELECT * FROM tablas.producto WHERE stock > 0 ORDER BY nombre ASC";//Verificar ORDER BY
            ps = conexion.prepareStatement(query);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Producto producto = new Producto(
                    rs.getInt("id_producto"),
                    rs.getString("nombre"),
                    rs.getBigDecimal("precio_venta"),
                    rs.getInt("stock")
                );
                productos.add(producto);
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error " + e.toString());
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conexion != null) conexion.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar recursos " + e.toString());
            }
        }
        return productos;
    }
    
    public Producto getProductoPorId(int idProducto) {
        Conexion conn = new Conexion();
        Connection conexion = null;
        Producto producto = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conexion = conn.getConexion();
            String query = "SELECT * FROM tablas.producto WHERE id_producto = ?";
            ps = conexion.prepareStatement(query);
            ps.setInt(1, idProducto);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                producto = new Producto(
                    rs.getInt("id_producto"),
                    rs.getString("nombre"),
                    rs.getBigDecimal("precio_venta"),
                    rs.getInt("stock")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error " + e.toString());
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conexion != null) conexion.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar recursos " + e.toString());
            }
        }
        return producto;
    }
    
    public void insertarProducto(Producto producto) {
        Conexion conn = new Conexion();
        Connection conexion = null;
        PreparedStatement ps = null;
        
        try {
            conexion = conn.getConexion();
            String query = "INSERT INTO tablas.producto (nombre, precio_venta, stock) VALUES (?, ?, ?)";
            ps = conexion.prepareStatement(query);
            ps.setString(1, producto.getNombre());
            ps.setBigDecimal(2, producto.getPrecioVenta());
            ps.setInt(3, producto.getStock());
            
            ps.executeUpdate();
            
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error " + e.toString());
        } finally {
            try {
                if (ps != null) ps.close();
                if (conexion != null) conexion.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar recursos " + e.toString());
            }
        }
    }
    
    public void actualizarProducto(Producto producto) {
        Conexion conn = new Conexion();
        Connection conexion = null;
        PreparedStatement ps = null;
        
        try {
            conexion = conn.getConexion();
            String query = "UPDATE tablas.producto SET nombre = ?, precio_venta = ?, stock = ? WHERE id_producto = ?";
            ps = conexion.prepareStatement(query);
            ps.setString(1, producto.getNombre());
            ps.setBigDecimal(2, producto.getPrecioVenta());
            ps.setInt(3, producto.getStock());
            ps.setInt(4, producto.getIdProducto());
            
            ps.executeUpdate();
            
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error " + e.toString());
        } finally {
            try {
                if (ps != null) ps.close();
                if (conexion != null) conexion.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar recursos " + e.toString());
            }
        }
    }
    
    public void eliminarProducto(int idProducto) {
        Conexion conn = new Conexion();
        Connection conexion = null;
        PreparedStatement ps = null;
        
        try {
            conexion = conn.getConexion();
            String query = "DELETE FROM tablas.producto WHERE id_producto = ?";
            ps = conexion.prepareStatement(query);
            ps.setInt(1, idProducto);
            
            ps.executeUpdate();
            
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error " + e.toString());
        } finally {
            try {
                if (ps != null) ps.close();
                if (conexion != null) conexion.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar recursos " + e.toString());
            }
        }
    }
    
    // Método para actualizar el stock del producto
    public void actualizarStock(int idProducto, int nuevoStock) {
        Conexion conn = new Conexion();
        Connection conexion = null;
        PreparedStatement ps = null;
        
        try {
            conexion = conn.getConexion();
            String query = "UPDATE tablas.producto SET stock = ? WHERE id_producto = ?";
            ps = conexion.prepareStatement(query);
            ps.setInt(1, nuevoStock);
            ps.setInt(2, idProducto);
            
            ps.executeUpdate();
            
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error " + e.toString());
        } finally {
            try {
                if (ps != null) ps.close();
                if (conexion != null) conexion.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar recursos " + e.toString());
            }
        }
    }
    
    // Método para buscar productos por nombre
    public List<Producto> buscarProductosPorNombre(String nombre) {
        Conexion conn = new Conexion();
        Connection conexion = null;
        List<Producto> productos = new ArrayList<>();
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conexion = conn.getConexion();
            String query = "SELECT * FROM tablas.producto WHERE nombre LIKE ? ORDER BY nombre ASC";//Verificar si ORDER BY
            ps = conexion.prepareStatement(query);
            ps.setString(1, "%" + nombre + "%");
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Producto producto = new Producto(
                    rs.getInt("id_producto"),
                    rs.getString("nombre"),
                    rs.getBigDecimal("precio_venta"),
                    rs.getInt("stock")
                );
                productos.add(producto);
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error " + e.toString());
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conexion != null) conexion.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar recursos " + e.toString());
            }
        }
        return productos;
    }
    
    // Método para verificar si hay suficiente stock
    public boolean verificarStockSuficiente(int idProducto, int cantidadRequerida) {
        Conexion conn = new Conexion();
        Connection conexion = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        boolean stockSuficiente = false;
        
        try {
            conexion = conn.getConexion();
            String query = "SELECT stock FROM tablas.producto WHERE id_producto = ? AND stock >= ?";
            ps = conexion.prepareStatement(query);
            ps.setInt(1, idProducto);
            ps.setInt(2, cantidadRequerida);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                stockSuficiente = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error " + e.toString());
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conexion != null) conexion.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar recursos " + e.toString());
            }
        }
        return stockSuficiente;
    }
}